extends KinematicBody2D
class_name UnitController

var movement: Vector2
var tile_size: int
var is_moving: bool = false
export var animation_speed: float = 1

# Base the tile_size on the size of the texture used * sprite scale.
func _ready() -> void:
	tile_size = ($sprite as Sprite).texture.get_width() * ($sprite as Sprite).scale.x

# Stops the inputs if the unit didn't finish its movement.
func _physics_process(delta: float) -> void:
	if !is_moving:
		movement_loop()

# unit not moving, get movement to execute tween with "animation_speed"(export) speed.
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
	
	# movement is different from (0,0) : Player moved, starting the tween.
	if movement != Vector2():
		($tween as Tween).interpolate_property(self, "position", position, position + (movement.normalized()) * tile_size, animation_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		($tween as Tween).start()

# Unit moving, stop flickering animation and inputs.
func _on_tween_tween_started(object, key):
	($sprite as Sprite).visible = true
	($anim as AnimationPlayer).stop()
	is_moving = true

# Unit finished moving : inputs are free and flickering animation restarts.
func _on_tween_tween_completed(object: Object, key: NodePath) -> void:
	($anim as AnimationPlayer).play("idle")
	is_moving = false