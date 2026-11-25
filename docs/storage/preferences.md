# Preferences (shared_preferences)

Small, non-secret settings of the device, shared by every account on it.
Code lives in `HealthFinderMobileApp/lib/core/storage/`.

Only settings needed before sign-in or before the database can be opened live
here. Per-account settings and consents are in the local database
(`user_settings`, `consents`, see `database-schema.md`).

- [Keys](#keys)
- [Setup](#setup)
- [Reading and writing](#reading-and-writing)
- [Terms](#terms)
- [Adding a new setting](#adding-a-new-setting)
- [What does not belong here](#what-does-not-belong-here)

## Keys

| Key | Type | Default | Description |
|---|---|---|---|
| **General** | | | |
| `firstLaunchDone` | bool | `false` | Whether the app has been launched before. If not, secure storage is cleared (on iOS, old tokens and the DB key survive reinstall in the Keychain) |
| `onboardingCompleted` | bool | `false` | Whether to show the onboarding screens |
| `lastSeenAppVersion` | string? | `null` | App version at last launch. If changed, show "What's new" or run a one-time migration |
| `locale` | string? | `null` | UI language. `null` means follow the system |
| `themeMode` | string? | `null` | Light or dark theme. `null` means follow the system |
| **Notifications** | | | |
| `notificationPermissionAsked` | bool | `false` | Whether the system notification prompt has been shown. It can only be shown once; after that, direct the user to system settings |
| **Privacy & Data** | | | |
| `termsAcceptedVersion` | int? | `null` | Accepted version of the terms and privacy policy on this device. `null` means not accepted yet. See [Terms](#terms) |
| `appLockEnabled` | bool | `false` | Require Face ID or fingerprint to open the app |

Moved to the local database, per account: medication and mood reminders,
`repeatReminderMinutes`, `healthAlertsEnabled`, `recommendationsEnabled`
(table `user_settings`), and the AI chat consents (table `consents`).

## Setup

Already wired in; nothing to do in screens.

| File | Role |
|---|---|
| `app_preferences.dart` | `AppPreferences`: typed getters and setters for every key. A `ChangeNotifier` |
| `settings_scope.dart` | `SettingsScope`: provides `AppPreferences` to the widget tree |
| `consent_versions.dart` | `ConsentVersions`: current versions of the terms and consent texts |
| `consent.dart` | `ConsentType` and `Consent`: model of a row in the `consents` table. Storage comes with the database |
| `app_storage.dart` | `AppStorage.init()`: creates preferences and secure storage at startup, handles first launch |

`main.dart` loads all values once before `runApp` through `AppStorage`, and
`app.dart` wraps `MaterialApp` in `SettingsScope`:

```dart
WidgetsFlutterBinding.ensureInitialized();
final storage = await AppStorage.init();
runApp(App(preferences: storage.preferences));
```

Because values are cached in memory at startup, **getters are synchronous**.
Setters write to disk, then notify listeners.

## Reading and writing

Get the instance from the context:

| Call | Use in | Rebuilds the widget on change |
|---|---|---|
| `SettingsScope.of(context)` | `build` | Yes |
| `SettingsScope.read(context)` | callbacks (`onPressed`, `onChanged`) | No |

Read a value in `build`:

```dart
final settings = SettingsScope.of(context);

SwitchListTile(
  value: settings.appLockEnabled,
  onChanged: settings.setAppLockEnabled,
);
```

Write a value from a callback:

```dart
onPressed: () => SettingsScope.read(context).setLocale(const Locale('sk')),
```

Setters return `Future<void>`; `await` them only when the next step depends
on the value being saved.

### Typed values

Some keys are stored as strings but exposed as Flutter types:

| Getter | Type | Notes |
|---|---|---|
| `locale` | `Locale?` | `null` = follow the system. `setLocale(null)` resets it |
| `themeMode` | `ThemeMode` | `ThemeMode.system` is stored as no value |

### Outside widgets

Pass `AppPreferences` into controllers and services through the constructor,
the same way `MoodController` receives its repository. Do not read it from a
global.

## Terms

The terms are accepted before sign-in, when the account is not known yet, so
the acceptance is stored on the device:

```dart
await settings.setTermsAcceptedVersion(ConsentVersions.terms);
if (!settings.hasAcceptedCurrentTerms) { /* show terms */ }
```

After sign-in, a `terms` row is added to the `consents` table for the account.

The AI chat consents (`aiChat`, `aiContext`) are per account and live only in
the `consents` table. `ConsentVersions` and the `Consent` model are shared by
both.

### Changing a consent text

Bump the matching value in `ConsentVersions`. Stored consents for older
versions stop being valid, and the user is asked again.

### Backend

The backend does not store terms acceptance, consents or notification settings
yet: it has no endpoint for them. Once it does, they should be sent to it: the
server processes the chat data, so it must be able to prove consent, and it
sends health alerts and recommendations.

## Adding a new setting

Only for device settings. A setting that belongs to the user goes to the
`user_settings` table instead.

1. Add the key to `_Keys` and to `_Keys.all` in `app_preferences.dart`.
   Keys missing from `all` throw at runtime.
2. Add a getter with the default value and a setter using the private
   `_setBool` / `_setString` / `_setInt` helpers (they notify listeners).
3. Add a row to the [Keys](#keys) table in this file.

```dart
bool get exampleEnabled => _prefs.getBool(_Keys.exampleEnabled) ?? false;
Future<void> setExampleEnabled(bool value) =>
    _setBool(_Keys.exampleEnabled, value);
```

Do not rename or remove an existing key without a migration: values already
saved on users' phones would be lost or left behind.

## What does not belong here

shared_preferences stores values as plain text and keeps them only on the
device.

| Data | Where instead |
|---|---|
| API token, refresh token, database key | Secure storage |
| Per-account settings, consents | Local database (`user_settings`, `consents`) |
| Profile, medical card, medications, mood, chats, clinics | Local database |
| Per-medication reminder times | Local database (medication schedule) |
| Anything large or a list of records | Local database |
