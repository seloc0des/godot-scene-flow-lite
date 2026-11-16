# Quick Start: Scene Flow (Lite)

Goal: two rooms connected by doors, no code.

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

### In a 3D scene

Same steps, same buttons. When the top node of the open scene is a Node3D, **Add Door** and
**Add Spawn Point** build 3D nodes (an Area3D door, a Marker3D spawn point). The player faces the way the spawn point's -Z direction points. To see it, turn on Use Local Space (press T in the 3D view) so the arrows turn with the point: the player looks the opposite way to the blue arrow. Or use the Inspector: with Rotation Y at 0 the player faces -Z, and 180 makes it face +Z. The player has to be a Node3D (a
CharacterBody3D is the usual choice). A 2D player on a 3D spawn point, or the other way round,
is left where it is and a warning says so in the Output panel. The player's origin lands exactly on the point. Controller players have their origin at their feet, so a point on the floor is right for them. A character with its origin in the middle needs the point lifted by half its height. Scenes whose top
node is neither a Node2D nor a Node3D follow the node you selected.

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
- In 3D the dock's door is a 1.5 m wide, 2.2 m tall, 1 m deep box. Resize its shape to fit
  your doorway.

## Next

Checkpoints + respawn, world-state flags (the chest that stays open), press-E
doors, and key-gating → **upgrade.md**.
