# Upgrading to Scene Flow (Pro)

Scene Flow (Lite) is the free core: doors, spawn points, fades. **Scene Flow
(Pro)** adds the layer that makes the world remember.

| | Lite (free) | Pro |
|---|---|---|
| change_scene with fades + spawn placement | ✅ | ✅ |
| Touch-to-travel doors (mid-fade retry) | ✅ | ✅ |
| Named spawn points + default fallback | ✅ | ✅ |
| No-code chooser dock | ✅ | ✅ |
| Walk-on checkpoints + one-call respawn() | — | ✅ |
| Global world-state flags | — | ✅ |
| Per-scene flags ("this chest, this room") | — | ✅ |
| Save-aware (flags/checkpoint/scene via Save addon) | — | ✅ |
| Press-E doors | — | ✅ |
| locked / required_flag key-gating + locked_attempt | — | ✅ |
| return_to_saved_scene() after loads | — | ✅ |
| Checkpoint dock button | — | ✅ |

Your Lite scenes carry forward — Pro's door/spawn/autoload use the same names
for everything Lite has, plus the new exports.

Get it on itch.io. MIT-licensed; use it in commercial projects.
