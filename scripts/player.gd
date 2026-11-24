extends CharacterBody2D
@export var max_health:float
@export var speed :float
@export var dash_speed:float
@onready var hand = $pivot/CharacterBody2D
@onready var weapon = $pivot/CharacterBody2D/Area2D
@onready var _weapon_sprite = $pivot/CharacterBody2D/Area2D/Sprite2D
@onready var dash_timer = $Timer
@onready var dash_cooldown_timer = $Timer2
@onready var knockback_timer = $knockback_timer
@onready var health_bar = $Camera2D/TextureProgressBar
@onready var health_label = $Camera2D/TextureProgressBar/Label
@onready var wave_display = $Label
@onready var _upgrades = $Upgrades
@onready var _animplayer = $AnimationPlayer
@onready var pickup_range = $PickupRange
@onready var money_display = $Label3

var money = 0

var _class:Class_Resource

var projectile_scene:PackedScene

var direction

var current_health = 1

var can_dash = true


var is_dashing = false
var is_being_knocked_back = false


func _ready() -> void:
	current_health = max_health
	_class = Global.player_class
	speed = _class.speed
	dash_speed = _class.dash_speed
	max_health = _class.max_health
	weapon.current_weapon = _class.starting_weapon
	current_health = max_health
func _physics_process(_delta):
	Global.Player = self
	_apply_buffs()
	if velocity != Vector2.ZERO:
		if is_being_knocked_back == true:
			pass
		elif is_dashing == true:
			pass
		else:
			_animplayer.play("walk")
	else:
		if _animplayer.current_animation == "walk":
			_animplayer.stop()
	round(current_health)
	money_display.text = str(money)
	wave_display = $"../enemy_spawn"
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_label.text = str(current_health)
	if !is_dashing or is_being_knocked_back:
		direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
		velocity = direction * speed
	$pivot.look_at(weapon.target_pos)
	#weapon.global_position = $Area2D/Marker2D2.global_position
	#weapon.global_position= $Area2D/Marker2D2.global_position
	#weapon.get_global_mouse_position().normalized()
	if speed < 0:
		speed = 0
	if dash_speed < 0:
		dash_speed = 0
	if is_dashing:
		if velocity == Vector2.ZERO:
			is_dashing = false
	if weapon.weapon_type == weapon.WEAPONTYPE.ranged:
		if weapon.global_position < global_position:
			_weapon_sprite.flip_v = true
			weapon.h_dir = "left"
		else:
			_weapon_sprite.flip_v = false
			weapon.h_dir = "right"
	else:
		if weapon.global_position < global_position:
			_weapon_sprite.flip_v = true
			_weapon_sprite.offset.y *= 1
			weapon.h_dir = "left"
		else:
			weapon.h_dir = "right"
			_weapon_sprite.flip_v = false
			_weapon_sprite.offset.y = abs(_weapon_sprite.offset.y)
	if Input.is_action_just_pressed("dash") and is_dashing == false and can_dash == true:
		is_dashing = true
		if velocity != Vector2.ZERO:
			velocity = direction * dash_speed
			can_dash = false
			dash_timer.start(0.5)
			set_collision_layer_value(1,false)
			set_collision_mask_value(1,false)
			dash_cooldown_timer.start(1.5)
	if current_health <= 0:
		get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
	move_and_slide()


func _on_timer_timeout() -> void:
	is_dashing = false
	set_collision_layer_value(1,true)
	set_collision_mask_value(1,true)

func _on_timer_2_timeout() -> void:
	can_dash = true


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") or body.is_in_group("EnemyProjectile"):
		is_being_knocked_back = true
		var dir = global_position.direction_to(body.global_position) * -1
		velocity = dir* speed * get_physics_process_delta_time()


func _on_knockback_timer_timeout() -> void:
	is_being_knocked_back = false


func _apply_buffs():
	var temp_upgrade = _upgrades.get_child(0)
	if temp_upgrade != null:
		weapon.damage += temp_upgrade.damage_buff
		weapon.pierce += temp_upgrade.pierce_buff
		weapon.cooldown +=temp_upgrade.cooldown_buff
		speed +=temp_upgrade.speed_buff
			#weapon.projectile_lifetime +=temp_upgrade.projectile_lifetime_buff
		temp_upgrade.queue_free()


func _on_pickup_range_area_entered(area: Area2D) -> void:
	if area.is_in_group("Pickup"):
		area.queue_free()
		money += 1
