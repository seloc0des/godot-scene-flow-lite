extends Node

# Marketing capture harness. Not shipped (build-packages.sh strips capture.*).
# Needs a real display, NOT --headless:
#   DISPLAY=:1 godot --path . --resolution 900x600 tools/capture.tscn -- \
#     --scene=res://demo/loot_demo.tscn --tag=loot --tl="w:30;click:Roll ×10;w:20;still:hero"
#
# Timeline steps, semicolon separated:
#   s:<secs>          wait (seconds - use this, not w:)
#   w:<frames>        wait N rendered frames. vsync is off so this is NOT time.
#   click:<btn text>  glide the drawn cursor to a Button and press it for real
#   hold:<action>:<secs>       hold a key down
#   hold2:<a>:<b>:<secs>       two keys at once, for diagonals
#   press:/rel:<action>        raw action press/release
#   fire:<action>     dispatch a real InputEventAction (_unhandled_input handlers)
#   still:<name>      save .capture/<tag>_<name>.png at full res
#   rec:on / rec:off  frame recording for the GIF
#
# Add --root when the pack changes scenes on its own (doors, checkpoints).
# The OS cursor isn't in the framebuffer, so we draw our own.

const OUT_DIR := "res://.capture"
const REC_HZ := 12.0

var _scene := ""
var _tag := "shot"
var _timeline := ""
var _as_root := false
var _rec := false
var _frame_no := 0
var _last_rec := 0.0
var _cursor: Cursor


class Cursor extends Control:
	var pos := Vector2(60, 60)
	var down := false

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		set_anchors_preset(Control.PRESET_FULL_RECT)

	func _draw() -> void:
		var p := pos
		var arrow := PackedVector2Array([
			p, p + Vector2(0, 17), p + Vector2(4.5, 12.5),
			p + Vector2(8, 19), p + Vector2(11, 17.5),
			p + Vector2(7.5, 11), p + Vector2(13, 10.5),
		])
		if down:
			draw_circle(p + Vector2(6, 8), 17.0, Color(1, 1, 1, 0.22))
		draw_colored_polygon(arrow, Color(0, 0, 0, 0.85))
		draw_polyline(arrow + PackedVector2Array([p]), Color(1, 1, 1, 0.95), 1.6)


func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--scene="): _scene = a.substr(8)
		elif a.begins_with("--tag="): _tag = a.substr(6)
		elif a.begins_with("--tl="): _timeline = a.substr(5)
		elif a == "--root": _as_root = true
	if _scene == "":
		push_error("no --scene=")
		get_tree().quit(1)
		return

	var packed: PackedScene = load(_scene)
	if packed == null:
		push_error("could not load %s" % _scene)
		get_tree().quit(1)
		return
	if _as_root:
		# Packs that change scenes (doors, checkpoints) would free us along with
		# the old current scene if we hosted the demo as a child. Hand the
		# current-scene slot to the demo and sit beside it under root instead.
		get_tree().current_scene = null
		get_tree().change_scene_to_packed(packed)
		await get_tree().process_frame
		await get_tree().process_frame
	else:
		add_child(packed.instantiate())

	var layer := CanvasLayer.new()
	layer.layer = 128
	add_child(layer)
	_cursor = Cursor.new()
	layer.add_child(_cursor)

	DirAccess.make_dir_recursive_absolute(OUT_DIR)
	DirAccess.make_dir_recursive_absolute(OUT_DIR + "/frames")
	_purge_frames()

	await _sleep(1.0)  # let autoloads, physics and any fade-in settle
	for step in _timeline.split(";", false):
		await _run(step.strip_edges())
	await _wait(10)
	print("[capture] %s done, %d gif frames" % [_tag, _frame_no])
	get_tree().quit()


func _run(step: String) -> void:
	var op := step.get_slice(":", 0)
	var arg := step.substr(op.length() + 1)
	match op:
		"w": await _wait(int(arg))
		"rec": _rec = arg == "on"
		"press": _act(arg, true)
		"rel": _act(arg, false)
		"fire": await _fire(arg)
		"s": await _sleep(float(arg))
		"hold":  # hold:<action>:<secs>
			var ha := arg.get_slice(":", 0)
			_act(ha, true)
			await _sleep(float(arg.get_slice(":", 1)))
			_act(ha, false)
		"hold2":  # hold2:<a>:<b>:<secs> — two keys at once, for diagonals
			var a1 := arg.get_slice(":", 0)
			var a2 := arg.get_slice(":", 1)
			_act(a1, true); _act(a2, true)
			await _sleep(float(arg.get_slice(":", 2)))
			_act(a1, false); _act(a2, false)
		"still": await _still(arg)
		"click": await _click(arg)
		_: push_warning("unknown step: %s" % step)


func _act(action: String, pressed: bool) -> void:
	if not InputMap.has_action(action):
		push_warning("no action %s" % action)
		return
	if pressed: Input.action_press(action)
	else: Input.action_release(action)


# Input.action_press only sets state; _unhandled_input handlers need a real event.
func _fire(action: String) -> void:
	if not InputMap.has_action(action):
		push_warning("no action %s" % action)
		return
	var ev := InputEventAction.new()
	ev.action = action
	ev.pressed = true
	Input.parse_input_event(ev)
	await _wait(3)
	var up := InputEventAction.new()
	up.action = action
	up.pressed = false
	Input.parse_input_event(up)


func _click(text: String) -> void:
	var btn := _find_button(get_tree().root, text)
	if btn == null:
		push_warning("no button matching '%s'" % text)
		await _wait(5)
		return
	var target: Vector2 = btn.get_global_rect().get_center() - Vector2(6, 8)
	var from: Vector2 = _cursor.pos
	for i in range(20):
		var t := ease(float(i + 1) / 20.0, -2.2)  # ease-in-out, feels deliberate
		_cursor.pos = from.lerp(target, t)
		_cursor.queue_redraw()
		await _sleep(0.03)
	_cursor.down = true
	_cursor.queue_redraw()
	await _sleep(0.12)
	if btn is Button and not btn.disabled:
		btn.pressed.emit()
	_cursor.down = false
	_cursor.queue_redraw()
	await _sleep(0.18)


func _find_button(n: Node, text: String) -> Button:
	if n is Button and text.to_lower() in String(n.text).to_lower():
		return n
	for c in n.get_children():
		var hit := _find_button(c, text)
		if hit != null:
			return hit
	return null


# Frame counts are meaningless here: vsync is off, so the demo renders at a few
# hundred fps and a "150 frame" walk covers a fraction of the ground you expect.
# Everything that matters is timed in seconds against the real clock.
func _sleep(secs: float) -> void:
	var until := Time.get_ticks_msec() + int(secs * 1000.0)
	while Time.get_ticks_msec() < until:
		await get_tree().process_frame
		await _maybe_rec()


func _wait(frames: int) -> void:
	for i in frames:
		await get_tree().process_frame
		await _maybe_rec()


func _maybe_rec() -> void:
	if not _rec:
		return
	var now := Time.get_ticks_msec() / 1000.0
	if now - _last_rec < 1.0 / REC_HZ:
		return
	_last_rec = now
	await _rec_frame()


func _rec_frame() -> void:
	await RenderingServer.frame_post_draw
	var img: Image = get_viewport().get_texture().get_image()
	img.save_png("%s/frames/%s_%04d.png" % [OUT_DIR, _tag, _frame_no])
	_frame_no += 1


func _still(name: String) -> void:
	await RenderingServer.frame_post_draw
	var path := "%s/%s_%s.png" % [OUT_DIR, _tag, name]
	var img: Image = get_viewport().get_texture().get_image()
	var err: int = img.save_png(path)
	print("[still] %s %s" % ["ok" if err == OK else "err %d" % err, path])


func _purge_frames() -> void:
	var d := DirAccess.open(OUT_DIR + "/frames")
	if d == null: return
	for f in d.get_files():
		if f.begins_with(_tag + "_"):
			d.remove(f)
