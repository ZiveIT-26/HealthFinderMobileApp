# Secure storage (flutter_secure_storage)

Secrets of the mobile app. Code lives in
`HealthFinderMobileApp/lib/core/storage/secure_store.dart`.

Diagrams: [storage-schemas.drawio](storage-schemas.drawio), pages "Secure storage" and "Flows".

- iOS: Keychain, accessible after the first unlock, this device only (no iCloud sync).
- Android: values encrypted with a Keystore-protected key.

Only small secrets go here. Everything else: see `preferences.md` and the local database.

## Keys

| Key | Value | Written by | Removed by |
|---|---|---|---|
| `accessToken` | Token for API requests, issued by our backend after Google sign-in | `writeAccessToken` | `clearSession`, `deleteAll` |
| `refreshToken` | Token to get a new access token, if the backend issues one | `writeRefreshToken` | `clearSession`, `deleteAll` |
| `databaseKey` | 256-bit hex key of the encrypted local database. Generated on first use | `databaseKey()` | `deleteDatabaseKey`, `deleteAll` |

Google's own tokens are not stored: `google_sign_in` manages them, and the
Google ID token is only sent to the backend once to get `accessToken`.

## Startup

`AppStorage.init()` in `main.dart` creates `AppPreferences` and `SecureStore`
and handles a fresh install:

```dart
final storage = await AppStorage.init();
runApp(App(preferences: storage.preferences));
```

On iOS the Keychain survives uninstalling the app, while shared_preferences
does not. If `firstLaunchDone` is `false`, everything in secure storage is
left over from an old install, so it is deleted before the app starts.

## API

| Method | Returns | Notes |
|---|---|---|
| `readAccessToken()` | `Future<String?>` | `null` if not signed in |
| `writeAccessToken(token)` | `Future<void>` | |
| `readRefreshToken()` | `Future<String?>` | |
| `writeRefreshToken(token)` | `Future<void>` | |
| `clearSession()` | `Future<void>` | Deletes both tokens. Keeps the database key |
| `databaseKey()` | `Future<String>` | Creates the key on first call, then returns the same one. Cached in memory |
| `deleteDatabaseKey()` | `Future<void>` | Only together with deleting the database |
| `deleteAll()` | `Future<void>` | Fresh install, "Delete local data" |

### Passing it around

`SecureStore` is not in the widget tree: screens never need tokens or keys.
Pass `storage.secure` through the constructor to whatever needs it, such as
the API client or the database.

### Typical flows

Sign-in:
```dart
await secure.writeAccessToken(response.accessToken);
if (response.refreshToken != null) {
  await secure.writeRefreshToken(response.refreshToken!);
}
```

API request:
```dart
final token = await secure.readAccessToken();
headers['Authorization'] = 'Bearer $token';
```

Sign-out (local health data stays on the phone):
```dart
await secure.clearSession();
```

Delete local data (Privacy & Data):
```dart
// delete the database file first, then:
await secure.deleteAll();
```

Read tokens once and keep them in memory where possible: every call goes
through a platform channel and is slow.

## Unreadable values

A read can fail temporarily (on iOS, before the first unlock after a reboot)
or permanently (the platform key a value was encrypted with is gone).

| Value | On a failed read |
|---|---|
| Tokens | Returns `null`, so the app behaves as signed out. The value is not deleted: a temporary failure does not end the session, and a broken value is overwritten on the next sign-in |
| `databaseKey` | Throws. The failure is not cached, so the next call tries again. A new key is never generated in this case, because the existing database could not be opened with it |

The database layer should catch the error from `databaseKey()` and retry
later instead of recreating the database.

## Platforms

### Android

| Topic | Setup |
|---|---|
| Encryption | Values encrypted with a key held in Android Keystore. No permissions needed |
| Minimum version | Android 6.0 (API 23). The project uses `flutter.minSdkVersion`, which is higher |
| Backups | Disabled for the whole app: `android:allowBackup="false"` in `AndroidManifest.xml` |
| Device-to-device transfer | Disabled by `res/xml/data_extraction_rules.xml` (Android 12+) |

Why backups are off: the Keystore key is never copied to another device, so
restored secure storage values could not be decrypted there. Health data
also should not leave the phone through system backups.

### iOS

| Topic | Setup |
|---|---|
| Storage | Keychain. No permissions or entitlements needed |
| Accessibility | `first_unlock_this_device`: readable after the first unlock since boot, so background work (e.g. reminders) can use it while the phone is locked |
| iCloud | Not synced: `this_device` items never leave the phone |
| Minimum version | iOS 15.0 (project deployment target) |
| Reinstall | Keychain survives uninstalling the app. Handled by `AppStorage.init()` on first launch |

Building and running on iOS requires a Mac with Xcode.

### To do with the local database (iOS)

App files are included in iCloud device backups by default. If a phone is
restored from a backup, the database file comes back but `databaseKey` does
not (it is `this_device`), so the database cannot be opened. The database
file must be excluded from backup when it is created.

### Web and desktop

Only for checking that the app starts. On web, values are encrypted with
WebCrypto and kept in the browser, which is not real secure storage. Running
on Windows requires Developer Mode (`start ms-settings:developers`).

## What does not belong here

| Data | Where instead |
|---|---|
| Settings, flags, consents | Preferences |
| Profile, medical card, medications, mood, chats, clinics | Local database |
| Anything large | Local database or files |
