extends CanvasLayer

# Shared demo HUD — instanced by both rooms. Narrates travel off the bus.

@onready var _status: Label = %Status


func _ready() -> void:
	_scene_flow_lite().scene_changed.connect(func(path: String) -> void:
		_status.text = "Entered %s" % path.get_file())


# SceneFlowLite is looked up when used instead of named. A script that names an
# autoload won't compile until the plugin that adds it is switched on, so a fresh
# install printed parse errors.
const SCENE_FLOW_LITE := preload("res://addons/scene_flow_lite/scene_flow_lite.gd")


static func _scene_flow_lite() -> SCENE_FLOW_LITE:
	return (Engine.get_main_loop() as SceneTree).root.get_node(^"SceneFlowLite") as SCENE_FLOW_LITE
