# Local database (encrypted)

Status: **planned, not implemented yet.** This file collects the decisions
made so far. Entities and fields: `database-schema.md`.
Related docs: `preferences.md`, `secure-storage.md`.

## Why a database

The app keeps structured, related data that has to be filtered and joined
(mood for a week, today's medications, clinics found in a chat) and must work
offline. Preferences and secure storage are for small key-value data only.

## What is stored

| Data | Source of truth | Local role | On sign-out |
|---|---|---|---|
| Profile | Backend | Cached copy, read by the profile screen | Cleared |
| Personal info | **Phone** | Only copy, per account | Kept |
| Medical card | **Phone** | Only copy, per account | Kept |
| Chats, messages | Backend | Full copy for offline reading | Cleared |
| Clinics found in chats | Backend (message payload) | Full copy for offline reading | Cleared |
| Medications, intakes, mood | **Phone** | Only copy. Designed later | Kept |

Not stored here: tokens and the database key (secure storage), settings and
consents (preferences), images (file cache).

## Engine and encryption

- `drift` on top of SQLite: typed queries, generated models, migrations.
- Encryption with SQLite3MultipleCiphers. Since drift 2.32.0 and sqlite3 3.x
  this works without `sqlcipher_flutter_libs`. The key is set in the `setup`
  callback of `NativeDatabase`, before drift uses the database.
- The key comes from `SecureStore.databaseKey()`: 256 random bits, generated
  on first use. Never derived from a user password and never hard-coded.
- Encryption is set up from the start. Converting an existing unencrypted
  database later is awkward.
- `PRAGMA foreign_keys = ON` on every connection (drift `beforeOpen`).
  SQLite has foreign keys off by default; without it cascades do not run.
- Enums are stored as text (their name), not as an index, so reordering an
  enum in Dart cannot corrupt data.
- `PRAGMA secure_delete = ON`: deleted rows are overwritten instead of staying
  in free pages of the file until the next `VACUUM`.

### One database for everything

Everything goes into a single encrypted database, including data that is not
sensitive on its own (clinics). The link "this chat found an oncology clinic"
already says something about the user's health. One database also means one
key, one migration path, joins across all tables, and one file for a future
backup. The cost of encryption is negligible.

## Data model conventions

See `database-schema.md` → "Conventions".

## Draft: medications and mood

Designed later, when the features are implemented. Not in `database-schema.md`
yet.

| Table | Main fields |
|---|---|
| `medications` | id, name, dosage, amount, schedule, startDate, endDate, updatedAt, deletedAt |
| `medication_intakes` | id, medicationId, scheduledAt, status (taken / skipped), markedAt, updatedAt |
| `mood_entries` | id, mood, note, createdAt, updatedAt, deletedAt |

Notes:

- Per-medication reminder times live in `medications`, not in preferences.
- Like the medical card, these tables will be kept per account (`ownerUserId`).

## Medical card: user-entered data

Users may enter their own diagnoses, not only blood type and allergies. This
is a personal health record, not an official medical record.

- All entries come from the user, so there is no `source` field. Label them
  as self-reported in the UI, e.g. "My records".

## AI chat and the medical card

- The medical card and medications may be sent to the chat as context only
  with `aiContextConsent` (see `preferences.md`).
- Send only the fields a request needs, not the whole card.
- The chat uses the card as context (e.g. allergies and current medications
  when answering). It does not assess risk, diagnose or give a "risk level":
  that would make the app a medical device under EU MDR.
- For worrying symptoms the chat always advises seeing a doctor or calling 112.
- The backend must not log request bodies, otherwise the card ends up on the
  server through logs. Check the LLM provider's data retention settings.
- Chat history itself is stored on the backend and contains health data, so
  `aiChatConsent` is required and the backend team must protect it.
- The backend's `user_memories` lets the LLM save allergies, conditions and
  medications mentioned in the chat. That is health data on the server, outside
  the medical card, and the user cannot see or delete it. To discuss with the
  backend team.

Not legal advice: have the consent texts reviewed before a real launch.

## Several accounts on one device

Phone-owned data is kept per account (`ownerUserId` = backend `user.id`), so a
second user signing in on the same phone does not see or delete the first
user's data. Only the signed-in user's data is shown; nothing when signed out.

- One database key for all accounts: the separation is in the queries, not in
  the encryption. Separate databases and keys per account were considered and
  are not needed for now.
- The owner filter lives in the repositories: every query on phone-owned
  tables filters by the signed-in user, and screens never see `ownerUserId`.
- Consents (`aiChatConsent`, `aiContextConsent`) stay in preferences, with the
  user id in the key: `aiContextConsent.<userId>`. A second account on the
  device starts without consents. "Delete my data" removes that user's keys.
  Temporary: later move them to a `consents` table in the database (encrypted,
  with a history of grants and revocations), or to the backend once it stores
  consents (it does not yet).

## Reading, refreshing, offline

- Screens always read from the database (drift queries can be watched as
  streams, so screens update when a table changes).
- Server-backed data: show the local copy, refresh from the API in the
  background, write the result to the database (stale-while-revalidate).
  The profile is the exception: there is no `GET /me`, it is refreshed only on
  sign-in.
- Offline:
  - all local data and cached chats / clinics are readable;
  - sending a chat message is blocked, the reply is generated on the server;
  - a network error never signs the user out, only a 401 that a token refresh
    cannot fix.
- First launch with no data and no connection: error state with "Try again".

## Files

- Avatars: `cached_network_image` in the cache folder. The system may clear
  it, then a placeholder is shown. The API returns no clinic photos.
- User attachments (photos of documents, test results), if added: sensitive,
  database encryption does not cover files, so they need separate encryption.
- The database file itself lives in the app data folder, not the cache folder.

## Platform notes

| Platform | Note |
|---|---|
| iOS | App files are in iCloud device backups by default. Exclude the database file from backup when creating it, otherwise a restored phone gets the file but not the key (`this_device`) |
| iOS | The key is readable after the first unlock since boot, so reminders can open the database while the phone is locked |
| Android | Backup and device transfer are already disabled for the whole app |

## Key problems

| Situation | Handling |
|---|---|
| `databaseKey()` throws | Temporary (e.g. iOS before the first unlock). Retry later. Never recreate the database because of this |
| File exists, key does not | The file cannot be opened (e.g. restored from a backup). Delete the file and start with an empty database |
| "Delete my data" | Per account. Hard delete (not `deletedAt`) of the signed-in user's `personal_info` and `medical_card` (lists cascade), removal of the user's consent keys, then sign-out (profile and chat cache cascade). Other accounts on the device are untouched. Server data (chats, memories) needs account deletion on the backend |

## Backup and sync (later)

Not part of the first version. If added:

- Backup, not sync: periodically upload the whole encrypted database file;
  on a new device download it whole. No merging, no conflicts.
- The server must not be able to decrypt it. Key options:
  - platform key sync (iCloud Keychain on iOS, Block Store on Android) as the
    main way;
  - a recovery code known only to the user as a fallback (e.g. iPhone →
    Android). Forgotten code = data cannot be restored.
  - A key held by the server is ruled out: the server would then store
    readable health data.
- Requires a separate consent.
- Simpler first step: export / import of an encrypted file by the user.

## Postponed

Discussed, not part of the schema for now. Each can be added later with a
migration.

- Vaccinations (name, date, note). No feature reads them yet: regional
  infection alerts (Epic 7) are not personal.
- Smoking and alcohol habits. Prevention tips (Epic 2) are generic, alcohol
  warnings (Epic 3) depend on the medication, not on the user.
- Diary of recent illnesses. Not in the epics; recent complaints are already in
  the chat history.

## Open questions

- Keep all chats locally, or only the last N?
- Height and weight: one current value, or history?
- Terms acceptance (`termsAcceptedVersion`): per device, or per account like
  the consents? It may be accepted before sign-in, when the user id is unknown.

To ask the backend team:

- `updatedAt` in `GET /chat/sessions`.
- `GET /me`, account deletion, and viewing / deleting `user_memories`.
- Refresh token: the backend issues none, but `SecureStore` has a slot for it.

## Next steps

1. Add `drift` with encryption, open the database with
   `SecureStore.databaseKey()`, enable foreign keys, exclude the file from iOS
   backup.
2. Tables for the phone-owned data: personal info, medical card and its lists.
3. Repositories on top of the tables, with the owner filter, replacing the
   mock data.
4. Google sign-in and the `Authorization` header, then the server-backed
   tables: profile, chats, messages, clinics.
5. Medications and mood, when those features are implemented.
