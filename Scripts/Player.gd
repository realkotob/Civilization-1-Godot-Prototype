extends KinematicBody2D
class_name UnitController

var movement: Vector2
var is_moving: bool = false
export var tile_size: int = 32
export var animation_speed: float = 1

func _physics_process(delta: float) -> void:
	if !is_moving:
		movement_loop()

func movement_loop() -> void:
	if Input.is_action_just_pressed("top"):
		movement = Vector2(0,-1)
	elif Input.is_action_just_pressed("top-right"):
		movement = Vector2(1,-1)
	elif Input.is_action_just_pressed("right"):
		movement = Vector2(1, 0)
	elif Input.is_action_just_pressed("down-right"):
		movement = Vector2(1, 1)
	elif Input.is_action_just_pressed("down"):
		movement = Vector2(0, 1)
	elif Input.is_action_just_pressed("down-left"):
		movement = Vector2(-1, 1)
	elif Input.is_action_just_pressed("left"):
		movement = Vector2(-1, 0)
	elif Input.is_action_just_pressed("top-left"):
		movement = Vector2(-1, -1)
	else:
		movement = Vector2()
		($anim as AnimationPlayer).play("idle")
	
	if movement != Vector2():
		($tween as Tween).interpolate_property(self, "position", position, position + (movement.normalized()) * tile_size, animation_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		($tween as Tween).start()

func _on_tween_tween_started(object, key):
	($sprite as Sprite).visible = true
	($anim as AnimationPlayer).stop()
	is_moving = true

func _on_tween_tween_completed(object: Object, key: NodePath) -> void:
	is_moving = false