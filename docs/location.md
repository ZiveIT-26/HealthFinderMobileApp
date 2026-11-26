# Location for doctor search

The assistant sorts doctors by distance. Where to search is the user's
choice each time, asked in the chat, with the home address as the fallback.

## How it works

1. The user asks for a doctor without naming a town.
2. The backend's model calls its `request_location` tool. The reply pauses
   and the stream sends `{"type":"location_request","requestId":"…"}`.
3. The chat shows a card inside the reply (`LocationRequestCard`):
   - **Use my current location**: asks for the permission if needed, reads
     the position once. Without permission or GPS, the saved home address
     is used instead, with a message saying so.
   - **Home · …**: the saved home address. Without one, **Set my home
     address** opens the map, saves it, and shares it.
   - **Not now**: the assistant searches without a location.
   - **Remember for this chat** (switch, on by default): see below.
4. The app answers with `POST /chat/location`, and the reply continues.
   Without an answer the server continues after 2 minutes; the card then
   says that no location was shared.

### Asked once per chat, read fresh every time

The user's *choice* is remembered, not the point:

- The server keeps a shared location for one reply only (in memory, not in
  its database). Every new message asks the app again.
- With **Remember for this chat** on, the app answers the next requests of
  the chat by itself, without the card: it reads the position again (the
  user may have moved) or takes the home address as it is saved now.
- With it off, the card is shown before every search.
- The **location line in the chat header** ("📍 Near home · Košice ▾") shows
  the choice and changes it at any moment: another choice for the rest of
  the chat, or "Ask me each time". If the user tells the assistant to search
  somewhere else, the request comes with `change: true` and the card is
  shown even with a remembered choice.
- "New chat" forgets the choice.
- Settings → Privacy & Data → **Remember location in a chat** sets the
  initial state of the switch (`chatLocationRemember`).

This is the app's own choice, separate from the system location permission
(Android "Only this time" / "While using the app"): the texts avoid the
words of the system dialog, so the two are not confused.

In an emergency the assistant never asks. See `HealthFinderBackend/docs/API.md`.

## What leaves the device

| Data | Goes to | Why |
| --- | --- | --- |
| Coordinates | our backend | sorting facilities by distance |
| Town and district ("Košice - Staré Mesto") | backend and the model | `find_doctors` needs a town |
| Street address of home | nowhere | shown on this device only |

The coordinates are never given to the model.

## Home address

Profile → Personal Information → Home location (`/home-location`, also
opened from the chat card).
Two ways to set it: move the map under the pin (or tap the map), or
**Use my current location**. The name comes from reverse geocoding on the
device (`geocoding`, no API key). Stored in `personal_info.fallbackLocation*`
(local database, per account). The screen also shows whether location access
is allowed, with a shortcut to the system settings.

## Permissions

- Android: `ACCESS_COARSE_LOCATION` and `ACCESS_FINE_LOCATION`, requested
  together on the first use (since Android 12 the user may allow only the
  approximate one, which is enough). No background location.
- iOS: `NSLocationWhenInUseUsageDescription`.
- The dialog appears only when the user taps a location button, never at
  startup. After "don't ask again", the app offers the system settings.

## Map

`maplibre_gl` with the OpenFreeMap "liberty" style: free, no API key or
account, commercial use allowed, OpenStreetMap data. MapLibre shows the
required attribution ("i" button); do not turn it off. OpenFreeMap has no
SLA; the tiles can be self-hosted later (github.com/hyperknot/openfreemap).
maplibre_gl needs Android 7.0 (API 24)+, iOS 15.5+ and JDK 21 for builds.

Android builds fail with `invalid source release: 21` when Flutter uses an
older JDK (it takes the one bundled with Android Studio; older versions ship
JDK 17). Fix: update Android Studio, or point Flutter at a JDK 21:
`flutter config --jdk-dir="<path to jdk-21>"` (check with `flutter doctor -v`).

## Emulator

Set a position: Extended controls (⋯) → Location, or
`adb emu geo fix 21.2611 48.7164` (longitude first).
