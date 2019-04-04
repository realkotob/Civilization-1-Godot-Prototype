extends KinematicBody2D
class_name UnitController

# MOVING VARIABLES
var movement: Vector2
var tile_size: int
var is_moving: bool = false
export var animation_speed: float = 1

# GAME VARIABLES
var attack: int = 1
var defense: int = 1
var total_movements: int = 3
var is_selected: bool = false
var turn_id: int
var movements_left: int

# FSM VARIABLES
var state: int
enum {IDLE, MOVING, SLEEPING, SELECTED}

# Base the tile_size on the size of the texture used * sprite scale.
func _ready() -> void:
	tile_size = ($sprite as Sprite).texture.get_width() * ($sprite as Sprite).scale.x
	state = SLEEPING

# PRESS SPACE TO ACTIVATE THE UNIT
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		movements_left = total_movements
		is_selected = true

# Stops the inputs if the unit didn't finish its movement.
func _physics_process(delta: float) -> void:
	if is_selected:
		movement_loop()
	state_loop()

func state_loop():
	if state == IDLE && movement != Vector2():
		change_state(MOVING)
	if state == MOVING && movement == Vector2():
		change_state(IDLE)
	if state == MOVING && movements_left <= 1:
		change_state(SLEEPING)
	if state == SLEEPING && is_selected:
		change_state(IDLE)

func change_state(new_state: int) -> void:
	state = new_state
	match state:
		IDLE:
			($anim as AnimationPlayer).play("idle")
		MOVING:
			($tween as Tween).interpolate_property(self, "position", position, position + movement * tile_size, animation_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			($tween as Tween).start()
		SLEEPING:
			($anim as AnimationPlayer).stop()
			is_selected = false
			print("animation stopped ! Go to unit having (turn_id +1) !")

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

#func create_unit(atk: int, def: int, moves: int):
#	attack = atk
#	defense = def
#	total_movements = moves

# Unit moving, stop flickering animation and inputs.
func _on_tween_tween_started(object, key):
	($sprite as Sprite).visible = true
	($anim as AnimationPlayer).stop()
	is_moving = true
	movements_left -= 1

# Unit finished moving : inputs are free and flickering animation restarts.
func _on_tween_tween_completed(object: Object, key: NodePath) -> void:
	is_moving = false