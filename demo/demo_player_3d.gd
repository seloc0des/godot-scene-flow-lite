extends CharacterBody3D

# Demo-only stand-in player so this pack stays standalone. In a real project the
# Controller pack (or your own player) replaces this. Scene Flow just needs
# something in the "player" group. The origin is at the feet (the shape and
# mesh sit half the capsule height up), like the Controller pack's players.

@export var speed: float = 5.0        ## m/s
@export var turn_speed: float = 12.0  ## how fast the body swings to face its way, per second


func _ready() -> void:
	add_to_group("player")


func _physics_process(delta: float) -> void:
	var input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity.x = input.x * speed
	velocity.z = input.y * speed
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	if input.length() > 0.1:
		var yaw := atan2(-input.x, -input.y)
		global_rotation.y = lerp_angle(global_rotation.y, yaw, clampf(turn_speed * delta, 0.0, 1.0))
