extends CharacterBody3D


@export var SPEED = 200.0
const JUMP_VELOCITY = 8.0
@onready var animator = get_node("AnimationPlayer") as AnimationPlayer

@export var view: Node3D
@export var health:= 5
var is_dead:= false
var gravity = 0
var movement_velocity: Vector3
var rotation_direction: float
var knockbacked:= false
var acabou:= false

@onready var coins_container: HBoxContainer = $HUD/coins_container
var coins = 0
var keys:= 0
var double_jump_available := false
var has_double_jumped:= false

@onready var player_start_position:= global_transform.origin

func _physics_process(delta: float) -> void:
	if not knockbacked:
		handle_input(delta)
	apply_gravity(delta)
	jump(delta)
	handle_animations()
	
	var applied_velocity: Vector3
	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity
	
	velocity = applied_velocity
	
	move_and_slide()
	
	
func handle_input(delta):
	var input:= Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_backward")
	
	input = input.rotated(Vector3.UP, view.rotation.y).normalized()
	if not knockbacked:
		velocity = input * SPEED * delta
		if Vector2(velocity.z, velocity.x).length() > 0:
			rotation_direction = Vector2(velocity.z, velocity.x).angle()
	
		rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)
	
func handle_animations():
	if not is_dead:
		if acabou:
			animator.play("VictorySign", 0.3)
		if is_on_floor():
			double_jump_available = true
			has_double_jumped = false
			if abs(velocity.x) > 1 or abs(velocity.z) > 1:
				animator.play("Run", 0.3)
			else:
				animator.play("Idle", 0.3)
		else:
			if has_double_jumped:
				animator.play("Flip", 0.3)
			else:
				animator.play("Jump", 0.3)
			
		if knockbacked:
			animator.play("Fall", 0.3)
			
		if not is_on_floor() and gravity > 2:
			animator.play("Fall", 0.3)
	else:
		animator.play("Dead", 0.3)
		await animator.animation_finished
		get_parent().get_node("GameOver").visible = true
		get_tree().paused = true

func apply_gravity(delta):
	if not is_on_floor():
		gravity += 25 * delta
	
func jump(delta):
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			gravity = -JUMP_VELOCITY
		elif double_jump_available:
			gravity = -JUMP_VELOCITY * 1.2
			double_jump_available = false
			has_double_jumped = true
			
	if gravity > 0 and is_on_floor():
		gravity = 0

func knockback(impact_point: Vector3, force: Vector3) -> void:
	coins_container.update_life(health)
	force.y = abs(force.y)
	velocity = force.limit_length(15.0)

func _on_hurtbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("damage"):
		_handle_damage()
		var body_collision = (body.global_position - global_position)
		var force = -body_collision
		force *= 10.0
		gravity = -5.0
		knockback(body_collision, force)
		_set_knockback()
	
func collect_coins():
	coins += 1
	coins_container.update_coin(coins)


func _on_stomp_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("breakables"):
		body.destroy_crate()
		gravity = -JUMP_VELOCITY
		


func _on_hurtbox_area_entered(area):
	if area.is_in_group("porta"):
		print("porta")
		acabou = true
	if area.is_in_group("damage"):
		_handle_damage()
		var area_collision = (area.global_position - global_position)
		var force = -area_collision
		force *= 10.0
		gravity = -5.0
		knockback(area_collision, force)
		_set_knockback()
	
func _handle_damage():
	if health > 0:
		health -= 1
	else:
		is_dead = true
			
func _set_knockback():
	knockbacked = true
	await get_tree().create_timer(0.3).timeout
	knockbacked = false
	
func respawn_player() -> void:
	_handle_damage()
	coins_container.update_life(health)
	transform.origin = player_start_position
	
func collect_key():
	keys += 1
	coins_container.update_key(keys)
	if keys >= Global.total_keys:
		print("Fim de Jogo")
