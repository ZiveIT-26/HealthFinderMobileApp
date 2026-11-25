# Local database: notes

Decisions with their reasons, plans and open questions. How the database
works and how to use it: [local-database.md](local-database.md). Tables:
[database-schema.md](database-schema.md).

## Why a database

The app keeps structured, related data that has to be filtered and joined
(mood for a week, today's medications, clinics found in a chat) and must work
offline. Preferences and secure storage are for small key-value data only.

## Why this engine and setup

- `drift` on top of SQLite: typed queries, generated models, migrations.
- SQLite3MultipleCiphers through the sqlite3 build hook, so no SQLCipher
  package is needed (drift 2.32.0+, sqlite3 3.x).
- The key is random (from `SecureStore`), never derived from a user password
  and never hard-coded.
- Encryption from the start: converting an existing unencrypted database
  later is awkward.
- Enums by name, not by index: reordering an enum in Dart cannot corrupt data.
- `secure_delete`: deleted rows are overwritten instead of staying in free
  pages of the file until the next `VACUUM`.

### One database for everything

Everything goes into a single encrypted database, including data that is not
sensitive on its own (clinics). The link "this chat found an oncology clinic"
already says something about the user's health. One database also means one
key, one migration path, joins across all tables, and one file for a future
backup. The cost of encryption is negligible.

## Medical card: user-entered data

Users may enter their own diagnoses, not only blood type and allergies. This
is a personal health record, not an official medical record.

- All entries come from the user, so there is no `source` field. Label them
  as self-reported in the UI, e.g. "My records".

## AI chat and the medical card

- The medical card and medications may be sent to the chat as context only
  with the `aiContext` consent (table `consents`).
- Send only the fields a request needs, not the whole card.
- The chat uses the card as context (e.g. allergies and current medications
  when answering). It does not assess risk, diagnose or give a "risk level":
  that would make the app a medical device under EU MDR.
- For worrying symptoms the chat always advises seeing a doctor or calling 112.
- The backend must not log request bodies, otherwise the card ends up on the
  server through logs. Check the LLM provider's data retention settings.
- Chat history itself is stored on the backend and contains health data, so
  the `aiChat` consent is required and the backend team must protect it.
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
- Settings that belong to the user (reminders, server notifications) and
  consents are in the database too (`user_settings`, `consents`), not in
  preferences. Preferences keep only device settings that are needed before
  sign-in or before the database can be opened (language, theme, onboarding,
  app lock, first launch, terms accepted before sign-in).
- A second account on the device starts with default settings and without
  consents.

## Reading, refreshing, offline (planned)

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

## Draft: medications and mood

Designed later, when the features are implemented. Not in
`database-schema.md` yet.

| Table | Main fields |
|---|---|
| `medications` | id, name, dosage, amount, schedule, startDate, endDate, updatedAt, deletedAt |
| `medication_intakes` | id, medicationId, scheduledAt, status (taken / skipped), markedAt, updatedAt |
| `mood_entries` | id, mood, note, createdAt, updatedAt, deletedAt |

Notes:

- Per-medication reminder times live in `medications`, not in preferences.
- Like the medical card, these tables will be kept per account (`ownerUserId`).
- Scheduled notifications belong to the device, not to the account. On every
  sign-in and sign-out cancel all of them and schedule only the current user's.
  When nobody is signed in there are no reminders; tell the user on sign-out.
- iOS keeps at most 64 pending local notifications. Schedule a few days ahead
  and reschedule everything on app start and on every change, so no mapping
  table between notifications and records is needed.

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

## Decided

- All chats are kept locally for now; a limit (last N) may come later.
- Height and weight: one current value each, no history.
- Sign-in: Google (`POST /auth/google`), also for the demo.
- Location for doctor search: the current position when available, the
  home location as fallback. The home location is set in settings in two
  ways: from the current GPS position or by picking a point on a map. Its
  display name comes from reverse geocoding of the point. Stored in the
  existing `fallbackLocation*` fields of `personal_info`.

## Open questions

To ask the backend team:

- `updatedAt` in `GET /chat/sessions`.
- `GET /me`, account deletion, and viewing / deleting `user_memories`.
- Refresh token: the backend issues none, but `SecureStore` has a slot for it.

## Next steps

Done: drift with encryption, tables, repositories, `CurrentUser`,
`AccountService`, profile and medical card screens read from the database,
Google sign-in with the `Authorization` header (`lib/core/auth/`), sign-out
button in the profile.

1. Check on devices: a database whose first opening failed (key not readable
   yet) opens on a later query; the iOS backup exclusion channel works.
2. ~~Google sign-in and the `Authorization` header; `AccountService.signIn`
   with the backend's user; remove the development account.~~ Done; the
   development account is now behind the "Test login" button.
3. `ChatApi`: `GET /chat/sessions` and `GET /chat/history/:id`, written into
   `ChatCacheRepository`; `ChatController` writes prompts, replies and titles
   into the cache.
4. UI: medical card and personal info forms, settings switches, sign-out,
   "Delete my data".
5. Tests of the repositories on an in-memory database.
6. Medications and mood, then reminders (see the draft above).
