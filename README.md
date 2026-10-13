# Scene Flow (Lite)

Free no-code scene travel for **Godot 4.5+**. Doors that walk between scenes
with fade transitions and named spawn points — baked onto any node from the
editor chooser dock.

Free Lite tier of the SELODEV **Scene Flow** addon. Pro adds checkpoints +
one-call respawn, world-state flags (global and per-scene, save-aware),
press-E doors, and locked/key-gated doors.

## 5-minute setup

1. Copy `addons/scene_flow_lite/` into your project.
2. Enable **Scene Flow (Lite)** in Project Settings → Plugins.
3. In room B: select a spot, type an id (`west`), click **Add Spawn Point**.
   In room A: select a node, click **Pick…** to choose room B, pick `west`
   under **Door lands on**, click **Add Door**.
4. In each room, select your player node and click **Make the selected node
   the player** (the Controller packs already do this).

Walk into the door — fade out, swap, land on the spawn point, fade in. Zero code.

## What it does

- **`SceneFlowLite.change_scene(path, spawn)`** — fade → swap → drop everything
  in the `"player"` group on the named spawn point → fade in. Signals:
  `scene_changing/changed`, `faded_out/in`.
- `SceneDoorLite` — touch-to-travel; retries politely if touched mid-fade.
- `SceneSpawnPointLite` — named landing spots (`"west"`, `default` fallback).
- **Chooser dock** — bake doors and spawn points onto the selected node.

## Verify

```bash
godot --headless --path . res://tools/verify.tscn   # prints PASS, incl. real scene swaps
```
Or open `tools/acceptance.tscn` and press F6 for a PASS/FAIL banner.

## License

MIT. Use it in commercial games.


## Part of a family

This is one free tier from the selodev catalog of no-code Godot 4 systems. They share an item contract and a save contract, so they plug into each other, and each one also works fully on its own.

Free systems:

- [Inventory Lite](https://github.com/seloc0des/godot-inventory-lite)
- [Equipment Lite](https://github.com/seloc0des/godot-equipment-lite)
- [Loot Lite](https://github.com/seloc0des/godot-loot-lite)
- [Crafting Lite](https://github.com/seloc0des/godot-crafting-lite)
- [Vendor Lite](https://github.com/seloc0des/godot-vendor-lite)
- [Quests Lite](https://github.com/seloc0des/godot-quests-lite)
- [Stats / Skills Lite](https://github.com/seloc0des/godot-stats-skills-lite)
- [Save / Load Lite](https://github.com/seloc0des/godot-save-load-lite)
- [Dialogue Lite](https://github.com/seloc0des/godot-dialogue-lite)
- [Combat Lite](https://github.com/seloc0des/godot-combat-lite)
- [Controller Lite](https://github.com/seloc0des/godot-controller-lite)
- [Enemy AI Lite](https://github.com/seloc0des/godot-enemy-ai-lite)
- [Scene Flow Lite](https://github.com/seloc0des/godot-scene-flow-lite)
- [Audio Lite](https://github.com/seloc0des/godot-audio-lite)
- [Level Builder Lite](https://github.com/seloc0des/godot-level-builder-lite)
- [Weather System Lite](https://github.com/seloc0des/godot-weather-lite)
- [Settings + Menus](https://github.com/seloc0des/godot-settings-menus) (complete and free, no paid tier)

Free VFX: [Magic Cast](https://github.com/seloc0des/godot-magic-cast-vfx-lite), [Elemental Impact](https://github.com/seloc0des/godot-elemental-impact-vfx-lite), [Explosion](https://github.com/seloc0des/godot-explosion-vfx-lite), [Pickup, Buff & Heal](https://github.com/seloc0des/godot-pickup-buff-vfx-lite).

Free starter projects: [Free Starter](https://github.com/seloc0des/free-starter-godot), [Dungeon](https://github.com/seloc0des/godot-dungeon-starter), [Survival](https://github.com/seloc0des/godot-survival-starter), [RPG](https://github.com/seloc0des/godot-rpg-starter).

The full versions add drop-in UI, editor docks and the cross-system wiring. They're on itch.io: **https://selodev.itch.io**
