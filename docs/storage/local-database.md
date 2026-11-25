# Local database (drift, encrypted)

Structured data of the mobile app: profile cache, personal info, medical card,
user settings, consents and the AI chat cache. One SQLite database encrypted
with SQLite3MultipleCiphers, accessed through `drift`.

- Tables and fields: [database-schema.md](database-schema.md)
- Decisions, open questions, plans: [local-database--notes.md](local-database--notes.md)
- Related: [preferences.md](preferences.md), [secure-storage.md](secure-storage.md)

Contents:

- [What is stored](#what-is-stored)
- [Code](#code)
- [Setup](#setup)
- [Using the repositories](#using-the-repositories)
- [Accounts](#accounts)
- [Changing a table](#changing-a-table)
- [Rules](#rules)
- [Errors and recovery](#errors-and-recovery)

## What is stored

| Data | Source of truth | Local role | On sign-out |
|---|---|---|---|
| Profile | Backend | Cached copy, read by the profile screen | Deleted |
| Personal info | **Phone** | Only copy, per account | Kept |
| Medical card and its lists | **Phone** | Only copy, per account | Kept |
| User settings, consents | **Phone** | Only copy, per account | Kept |
| Chats, messages | Backend | Full copy for offline reading | Deleted |
| Clinics found in chats | Backend (message payload) | Full copy for offline reading | Deleted |

Not stored here: tokens and the database key (secure storage), device
settings such as language, theme and app lock (preferences), images (file
cache).

## Code

| Part | Where |
|---|---|
| Tables | `lib/core/database/tables.dart` |
| Database class, migrations | `lib/core/database/app_database.dart` (+ generated `app_database.g.dart`) |
| Opening, encryption | `lib/core/database/connection.dart` |
| iOS backup exclusion | `lib/core/database/backup_exclusion.dart`, `ios/Runner/AppDelegate.swift` |
| Entities | `lib/features/*/data/models/` |
| Repositories | `lib/features/*/data/*_repository.dart`, `lib/core/storage/consent_repository.dart` |
| Signed-in user, sign-in / sign-out / "Delete my data" | `lib/core/session/` (`CurrentUser`, `AccountService`) |
| Access from widgets | `lib/core/data/repositories.dart` (`Repositories`, `RepositoriesScope`) |

## Setup

Already wired in. `main.dart` creates the storages and the repositories,
restores the session and passes them to `App`:

```dart
final storage = await AppStorage.init();      // preferences, secure store, database
final repositories = Repositories(storage);
await repositories.account.restore();         // who is signed in
runApp(App(preferences: storage.preferences, repositories: repositories));
```

`AppStorage` creates the database, but nothing is opened until the first
query. Opening (`connection.dart`):

1. Reads the key with `SecureStore.databaseKey()`: 32 random bytes as 64 hex
   characters, generated on first use.
2. Uses the file `Application Support/database/health_finder.sqlite`. The
   folder is excluded from iCloud backups.
3. If the file exists but the key cannot open it, deletes the file (see
   [Errors and recovery](#errors-and-recovery)).
4. Opens the database in a background isolate and, before drift uses it, sets
   the key (`PRAGMA key = 'raw:…'`, no key derivation), checks it with a
   query, and enables `foreign_keys` and `secure_delete`.

Encryption comes from the `hooks` section of `pubspec.yaml`, which bundles
SQLite3MultipleCiphers instead of plain SQLite. A debug assert fails if it is
missing. `sqlcipher_flutter_libs` is not needed.

### Development account

Until Google sign-in exists, debug builds sign in a local test account on
startup and fill its medical card once with sample data
(`lib/core/session/dev_account.dart`). Remove it together with its call in
`main.dart` once sign-in is implemented.

## Using the repositories

Get them from the context. `of` does not rebuild the widget; data changes
arrive through the `watch` streams.

```dart
final repositories = RepositoriesScope.of(context);
```

| Repository | Read | Write |
|---|---|---|
| `profile` | `get()`, `watch()` | Only through `AccountService` |
| `personalInfo` | `get()`, `watch()` | `save(PersonalInfo)` |
| `medicalCard` | `get()`, `watch()`: the card with all lists (`MedicalCardData`) | `saveCard(MedicalCard)`; per list `saveAllergy(item)`, `deleteAllergy(id)`, same for conditions, implants, surgeries, contacts |
| `userSettings` | `get()`, `watch()` | `save(UserSettings)` |
| `consents` | `isValid(type)`, `watchValid(type)`, `latest(type)` | `grant(type)`, `revoke(type)` |
| `chatCache` | `watchChats()`, `watchMessages(chatId)`, `clinic(id)` | `saveChatList`, `replaceHistory`, `startChat`, `appendMessage`, `setTitle` |
| `account` | | `signIn`, `signOut`, `deleteMyData` |

Per-account repositories throw `NotSignedInException` when nobody is signed
in. Check `repositories.currentUser.isSignedIn` first.

### Reading in a screen

Create the stream once, not in `build`, or every rebuild subscribes again:

```dart
class _MedicalCardScreenState extends State<MedicalCardScreen> {
  Stream<MedicalCardData>? _card;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _card ??= RepositoriesScope.of(context).medicalCard.watch();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<MedicalCardData>(
        stream: _card,
        builder: (context, snapshot) => /* snapshot.data */,
      );
}
```

### Writing

There are no setters per field. Change an entity with `copyWith` and save it
whole. `copyWith(note: null)` clears a nullable field, `copyWith()` keeps it.

| Screen | When to save |
|---|---|
| Form (medical card, personal info) | On "Save". The draft lives in the form state; fields are validated together and saved in one write |
| One list item (an allergy, a contact) | On "Save" of its dialog |
| Switches in settings | Immediately, there is no "Save" button for switches |

```dart
// Form "Save"
await repositories.medicalCard.saveCard(
  card.copyWith(bloodType: BloodType.aPositive, gpName: null),
);

// New list item: no id. Returns the new id.
await repositories.medicalCard.saveAllergy(
  const Allergy(name: 'Penicillin', kind: AllergyKind.allergy,
      category: AllergyCategory.medication),
);

// Switch
await repositories.userSettings.save(
  settings.copyWith(moodRemindersEnabled: value),
);
```

Saving a contact with `isPrimary: true` removes the flag from the previous
primary contact. Deleting a list item sets `deletedAt`; the item disappears
from `watch`.

## Accounts

`CurrentUser` holds the backend `user.id` of the signed-in user.
Repositories filter phone-owned data by it (`ownerUserId`), so screens never
deal with user ids. Only `AccountService` changes it:

| Method | Does |
|---|---|
| `restore()` | At startup: a cached profile means the user is still signed in |
| `signIn(profile)` | After the backend returned the account. Saves the profile, creates default settings for a new account, records terms accepted on the device. Another account's profile and chat cache are replaced |
| `signOut()` | Deletes the profile (the chat cache goes with it) and the tokens. Medical card, settings and consents stay for the next sign-in |
| `deleteMyData()` | Deletes the signed-in user's personal info, medical card, settings and consents for good, then signs out. Other accounts are untouched. Server data is not deleted |

## Changing a table

1. Edit `lib/core/database/tables.dart`.
2. Regenerate: `dart run build_runner build --delete-conflicting-outputs`
   (or keep `dart run build_runner watch --delete-conflicting-outputs`
   running). `flutter run` does not do it.
3. Update the entity, the repository mapping and `database-schema.md`.
4. Commit the generated `app_database.g.dart` with the change.

An existing database on a device is not migrated: `onCreate` runs only for a
new file. Before the first release, reinstall the app after a change. From
the first release, every change needs a migration step and a higher
`schemaVersion`.

## Rules

- Screens read from the database, never directly from the API. Network code
  writes into the repositories.
- Phone-owned tables are always filtered by the signed-in user inside the
  repository.
- Enums are stored by name (`textEnum`), dates as ISO-8601 text
  (`build.yaml`). Do not reorder or rename enum values without a migration.
- Row classes end in `Row` (`MedicalCardRow`); screens get entities, not rows.
- Do not log or print entities: they contain health data.

## Errors and recovery

| Situation | Handling |
|---|---|
| `databaseKey()` throws | Temporary (iOS before the first unlock after a reboot). The database is never recreated because of it. At startup the app continues as signed out |
| The file exists, the key cannot open it | The file can never be read again (restored from a backup, or the key was lost). It is deleted, and the app starts with an empty database |
| "Delete my data" | `AccountService.deleteMyData()`, see [Accounts](#accounts) |

| Platform | Note |
|---|---|
| iOS | App files are in iCloud device backups by default. The database folder is excluded, otherwise a restored phone gets the file but not the key (`this_device`) |
| iOS | The key is readable after the first unlock since boot, so background work can open the database while the phone is locked |
| Android | Backup and device transfer are disabled for the whole app |
