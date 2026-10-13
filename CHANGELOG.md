# Changelog: Scene Flow (Lite)

## 1.1.3 (2026-10-12)

The tabs show their names on Godot 4.5.

- **The Scene Flow Lite tab was blank on Godot 4.5.** Its tab beside the Inspector had no title, so
  "open the Scene Flow Lite tab" pointed at nothing. It is named when the pack switches on now.
  Godot 4.7 was not affected.

## 1.1.2 (2026-09-28)

- **A door on the spot you land on waits for you to step off it first.** The way back into a
  room usually sits where the way in drops you, and the door fired the moment the scene change
  placed the player on it, so two rooms bounced the player back and forth for ever. Now a
  player placed onto a door steps off and back on; every other door is unchanged.

## 1.1.1 (2026-09-27)

Installs without errors, and its tab works the moment you switch it on.

- **Its tab works the moment you switch it on.** Right after installing, some of its buttons only
  half-worked until you restarted Godot.
- **No red errors when you install it.** Installing it filled the Output panel with "Failed to
  load script" errors before you'd even switched it on. Some of its scripts named a part of the
  pack that only exists once the pack is on.
- **The tab fits a default-width dock.** The Scene Flow tab fits at any editor scale. A long "Door
  lands on" entry ends in "…" on the button instead of stretching the tab. The open list still shows
  it whole. The heading and long buttons wrap, and the tab scrolls when it is taller than the dock.

## 1.1.0 (2026-09-26)

- **Pick… chooses a door's target scene**, and **Door lands on** lists the spawn points in it. Add
  Door warns when the target has no spawn with that id.
- **Doors and spawn points tell you when nothing is marked as the player**, next to a **Make the
  selected node the player** button.
- **Nodes the dock adds don't run their game code in the editor**, and pressing Play right after a
  button includes what it added.
- **A second door or spawn point gets a readable name** instead of a generated one full of
  `@` signs.
- **Switching the plugin off only removes the autoload if the plugin added it**, and closing
  the editor no longer removes it at all. A project that declares it itself, like the starter
  kits, keeps it.
- **The Scene Flow Lite tab no longer cuts its text off.** It opened in a narrow column, so labels,
  file pickers and the notes at the bottom ran past the edge. It now asks for the same width as the
  other tabs.

## 1.0.1 — 2026-08-10

Safer download.

- **The download can't damage a project you're already working on.** It now unzips into one folder named after the pack, instead of putting files loose at the top. Before this, unzipping it straight into an existing game overwrote that game's name, its start-up scene and the list of add-ons you had switched on. It can't reach any of that now.
- **Added START-HERE.txt and INSTALLING.txt** at the top of the folder — what's in the download, the two-minute install, and what to do if something goes wrong. Plain text, opens anywhere.
- **Fixed: the docs pointed at a self-test file that wasn't there.** They said `tools/verify.tscn`; in the download it's `tools/scene_flow_lite/verify.tscn`. The paths now match what's actually in the box.

## 1.0.0

- Initial release.
- `SceneFlowLite` autoload: change_scene with fades + "player"-group spawn placement, is_changing guard.
- `SceneDoorLite`: touch-to-travel with mid-fade retry.
- `SceneSpawnPointLite`: named landing spots with `default` fallback.
- No-code chooser dock: bake doors and spawn points onto the selected node.
- Two-room demo with doors both ways.
- Headless `tools/verify.tscn` (13 checks, incl. real scene swaps) + `tools/acceptance.tscn` PASS/FAIL banner.
