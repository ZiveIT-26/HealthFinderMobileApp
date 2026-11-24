# Preferences (shared_preferences)

Small, non-secret settings of the mobile app. Code lives in
`HealthFinderMobileApp/lib/core/storage/`.

- [Keys](#keys)
- [Setup](#setup)
- [Reading and writing](#reading-and-writing)
- [Consents](#consents)
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
| `medicationRemindersEnabled` | bool | `true` | Medication intake reminders. Scheduled locally |
| `repeatReminderMinutes` | int? | `null` | Minutes before repeating a reminder if the intake isn't marked. `null` means no repeat |
| `moodRemindersEnabled` | bool | `true` | Daily "How are you feeling today?" reminder. Scheduled locally |
| `moodReminderTime` | string | `"20:00"` | Time of the mood reminder, `HH:mm` |
| `healthAlertsEnabled` | bool | `true` | Alerts: viral outbreaks, adverse weather, etc. Sent by the server, so also stored on the backend |
| `recommendationsEnabled` | bool | `false` | Tips and recommendations. Sent by the server, so also stored on the backend. Off by default to avoid feeling intrusive |
| **Privacy & Data** | | | |
| `termsAcceptedVersion` | int? | `null` | Accepted version of the terms and privacy policy. `null` means not accepted yet. Also recorded on the backend |
| `aiChatConsent` | bool | `false` | Consent to processing of data in the AI chat (on the server and by the LLM provider). Chat is unavailable without it. Also recorded on the backend |
| `aiChatConsentAt` | string? (date) | `null` | When chat consent was given |
| `aiChatConsentVersion` | int? | `null` | Version of the chat consent text. If outdated, ask again |
| `aiContextConsent` | bool | `false` | Consent to sending the medical card and medications to the chat as context. Also recorded on the backend |
| `aiContextConsentAt` | string? (date) | `null` | When context consent was given |
| `aiContextConsentVersion` | int? | `null` | Version of the context consent text. If outdated, ask again |
| `appLockEnabled` | bool | `false` | Require Face ID or fingerprint to open the app |

## Setup

Already wired in; nothing to do in screens.

| File | Role |
|---|---|
| `app_preferences.dart` | `AppPreferences`: typed getters and setters for every key. A `ChangeNotifier` |
| `settings_scope.dart` | `SettingsScope`: provides `AppPreferences` to the widget tree |
| `consent_versions.dart` | `ConsentVersions`: current versions of the terms and consent texts |
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

Switch(
  value: settings.moodRemindersEnabled,
  onChanged: settings.setMoodRemindersEnabled,
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
| `moodReminderTime` | `TimeOfDay` | Stored as `"HH:mm"` |
| `repeatReminderMinutes` | `int?` | `setRepeatReminderMinutes(null)` turns repeating off |

### Outside widgets

Pass `AppPreferences` into controllers and services through the constructor,
the same way `MoodController` receives its repository. Do not read it from a
global.

## Consents

Each consent is stored as three keys (granted, date, version) and exposed as
one `Consent` object. Always change consents through these methods, never key
by key:

```dart
final settings = SettingsScope.read(context);

await settings.grantAiChatConsent(ConsentVersions.aiChat);
await settings.revokeAiChatConsent();

await settings.grantAiContextConsent(ConsentVersions.aiContext);
await settings.revokeAiContextConsent();

await settings.setTermsAcceptedVersion(ConsentVersions.terms);
```

Check against the current version with the ready-made getters:

```dart
if (!settings.hasAcceptedCurrentTerms) { /* show terms */ }
if (!settings.hasAiChatConsent) { /* show chat consent, block the chat */ }
if (settings.hasAiContextConsent) { /* attach medical card to the request */ }
```

The raw record is available as `settings.aiChatConsent` /
`settings.aiContextConsent` (`granted`, `grantedAt`, `version`).

### Changing a consent text

Bump the matching value in `ConsentVersions`. Stored consents for older
versions stop being valid, and the `has...` getters return `false` until the
user agrees again.

### Backend

The local values only tell the UI what to show. Consents, terms acceptance,
`healthAlertsEnabled` and `recommendationsEnabled` must also be sent to the
backend, since the server processes the data and sends those notifications.

## Adding a new setting

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
| Profile, medical card, medications, mood, chats, clinics | Local database |
| Per-medication reminder times | Local database (medication schedule) |
| Anything large or a list of records | Local database |
