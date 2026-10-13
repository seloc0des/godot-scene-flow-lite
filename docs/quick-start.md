# Quick Start: Scene Flow (Lite)

Goal: two rooms connected by doors — no code.

## 1. Install

- Copy `addons/scene_flow_lite/` into your project.
- Enable **Scene Flow (Lite)** in Project Settings → Plugins.

## 2. Connect two rooms (dock)

In **room_b.tscn**:
- Select a spot just inside the entrance, type `west` in the **Spawn id**
  field, click **Add Spawn Point**.

In **room_a.tscn**:
- Select a node near the exit. In the **Scene Flow Lite** dock click **Pick…**
  and choose `room_b.tscn`. **Door lands on** now lists room B's spawn points:
  pick `west`, then click **Add Door**. If room B has no spawn points yet, type
  the id under **Spawn id** instead and add the matching spawn point later.

Press Play and walk into the door: fade out → room B → land on `west` → fade
in. (Anything in the `"player"` group is placed. The Controller packs do that
automatically. Otherwise select your player node in each room and click
**Make the selected node the player** in the dock.)

## 3. Travel from code (optional)

```gdscript
SceneFlowLite.change_scene("res://rooms/boss.tscn", &"entrance")
SceneFlowLite.fade_time = 0.8            # slower fades
SceneFlowLite.scene_changed.connect(func(path): print("now in ", path))
```

## Tips

- Keep spawn points a body-width away from the return door so travelers don't
  land inside it and bounce straight back.
- Both the door and the player need collision shapes (the dock adds the door's).

## Next

Checkpoints + respawn, world-state flags (the chest that stays open), press-E
doors, and key-gating → **upgrade.md**.
