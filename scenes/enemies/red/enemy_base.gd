extends CharacterBody2D
@export var enemy_stats:enemy_resource

@onready var _anim_player = $AnimationPlayer
@onready var _timer = $Timer
@onready var death_timer = $death_timer
@onready var projectile_timer = $Projectile_timer
@onready var special_attack_timer = $Special_attack_timer
@onready var special_attack_cooldown_timer = $special_attack_cooldown_timer
@onready var knockback_timer = $knockback_timer
@onready var player_range_detector = $Area2D2
@onready var player_range_exit_detector = $Area2D3
@onready var main = get_tree().get_root()
@onready var enemies = get_parent()

var coin = preload("res://scenes/coin.tscn")

var difficulty_scale:Curve

var player

var value:int


enum ENEMY_COLOUR {RED,GREEN,YELLOW,BLUE,PURPLE,GREY,ORANGE,MONOCHROME}
enum ENEMY_TYPE {BASIC,CHARGER,RUNNER,PASSIVE}

var projectiles_spawned = 0

var can_shoot_projectile = false
var can_use_special_attack = false
var is_using_special_attack = false

var is_in_player_range = false

var is_being_knocked_back = false
var stunned = false
var hit = false
var has_died = false

var dir:Vector2



var _name:String
var colour
var type
var max_health:int
var spawn_wave:int
var speed:float
var damage:int
var special_attack:bool
var special_attack_cooldown:float
var defense:int
var projectiles:bool
var projectile_speed:float
var projectile_spread:float
var projectile_amount:int
var projectile_cooldown
var projectile_scene:PackedScene
var current_health = 1

func _ready() -> void:
	_name = enemy_stats._name
	colour = enemy_stats.colour
	type = enemy_stats.type
	max_health = enemy_stats.max_health
	spawn_wave = enemy_stats.spawn_wave
	speed = enemy_stats.speed
	damage = enemy_stats.damage
	special_attack = enemy_stats.special_attack
	special_attack_cooldown = enemy_stats.special_attack_cooldown
	defense = enemy_stats.defense
	projectiles = enemy_stats.projectiles
	projectile_speed = enemy_stats.projectile_speed
	projectile_amount = enemy_stats.projectile_amount
	projectile_cooldown = enemy_stats.projectile_cooldown
	projectile_scene = enemy_stats.projectile_scene
	current_health = max_health
	value = enemy_stats.value
	difficulty_scale = enemy_stats.difficulty_scale
	projectile_timer.start(projectile_cooldown + randf_range(0,projectile_cooldown * 3))
	special_attack_cooldown_timer.start(special_attack_cooldown)

	damage *= difficulty_scale.sample(Global.current_wave)
	max_health *= difficulty_scale.sample(Global.current_wave)
	round(damage)
	round(max_health)
	if damage == 0:
		damage = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if type == ENEMY_TYPE.BASIC:
		if is_being_knocked_back == false:
			dir = global_position.direction_to(Global.Player.global_position)
			velocity = dir* speed * delta
			
	if type == ENEMY_TYPE.CHARGER:
		if !is_being_knocked_back:
			if can_use_special_attack ==true:
				velocity = dir* (speed * 10)* delta
				is_using_special_attack = true
				if can_use_special_attack == true and !is_being_knocked_back:
					can_use_special_attack = false
					dir = global_position.direction_to(Global.Player.global_position)
					special_attack_timer.start(special_attack_cooldown +randf_range(0,3))
			if is_using_special_attack == false:
				dir = global_position.direction_to(Global.Player.global_position)
				velocity = dir* speed * delta
	if type == ENEMY_TYPE.RUNNER:
		if is_being_knocked_back == false:
			if is_in_player_range == false:
				dir = global_position.direction_to(Global.Player.global_position)
				velocity = dir* speed * delta
			else:
				dir = global_position.direction_to(Global.Player.global_position) *-1
				velocity = dir* speed * delta
	if projectiles == true and can_shoot_projectile == true:
		if projectile_amount == 1:
			var new_projectile = projectile_scene.instantiate()
			new_projectile.speed = projectile_speed
			new_projectile.spawnpos = global_position
			new_projectile.damage = damage
			can_shoot_projectile = false
			projectile_timer.start(projectile_cooldown +  randf_range(0,projectile_cooldown * 3))
			enemies.add_child(new_projectile)
		elif projectile_amount == 2:
			for i in projectile_amount:
				projectiles_spawned +=1
				var new_projectile = projectile_scene.instantiate()
				new_projectile.speed = projectile_speed
				new_projectile.spawnpos = global_position
				if projectiles_spawned == 1:
					new_projectile.spawnrot = enemy_stats.proj_1_angle
				if projectiles_spawned == 2:
					new_projectile.spawnrot = enemy_stats.proj_2_angle
				new_projectile.damage = damage
				can_shoot_projectile = false
				projectile_timer.start(projectile_cooldown + randf_range(0,projectile_cooldown * 3))
				enemies.add_child(new_projectile)
			projectiles_spawned = 0
		elif projectile_amount == 3:
			for i in projectile_amount:
				projectiles_spawned +=1
				var new_projectile = projectile_scene.instantiate()
				new_projectile.speed = projectile_speed
				new_projectile.spawnpos = global_position
				if projectiles_spawned == 1:
					new_projectile.spawnrot = enemy_stats.proj_1_angle
				if projectiles_spawned == 2:
					new_projectile.spawnrot = enemy_stats.proj_2_angle
				if projectiles_spawned == 3:
					new_projectile.spawnrot = enemy_stats.proj_3_angle
				new_projectile.damage = damage
				can_shoot_projectile = false
				projectile_timer.start(projectile_cooldown + randf_range(0,projectile_cooldown * 3))
				enemies.add_child(new_projectile)
			projectiles_spawned = 0
		elif projectile_amount == 4:
			for i in projectile_amount:
				projectiles_spawned +=1
				var new_projectile = projectile_scene.instantiate()
				new_projectile.speed = projectile_speed
				new_projectile.spawnpos = global_position
				if projectiles_spawned == 1:
					new_projectile.spawnrot = enemy_stats.proj_1_angle
				if projectiles_spawned == 2:
					new_projectile.spawnrot = enemy_stats.proj_2_angle
				if projectiles_spawned == 3:
					new_projectile.spawnrot = enemy_stats.proj_3_angle
				if projectiles_spawned == 4:
					new_projectile.spawnrot = enemy_stats.proj_4_angle
				new_projectile.damage = damage
				can_shoot_projectile = false
				projectile_timer.start(projectile_cooldown +  randf_range(0,projectile_cooldown * 3))
				enemies.add_child(new_projectile)
			projectiles_spawned = 0
	if hit == true:
		stunned = true
		_timer.start(0.3)
		_anim_player.play("hit")
		hit = false
	elif velocity == Vector2.ZERO and stunned == false:
		_anim_player.play("idle")
	elif velocity != Vector2.ZERO and stunned == false:
		_anim_player.play("move")
	if has_died == false and current_health <= 0:
		death_timer.start(0.25)
		_anim_player.play("die")
		var worth_amount = randi_range(1,value)
		for i in worth_amount:
			var new_coin = coin.instantiate()
			new_coin.global_position = global_position
			new_coin.global_position.x += randf_range(-15,15)
			new_coin.global_position.y += randf_range(-15,15)
			enemies.add_child(new_coin)
		has_died = true
		queue_free()
	move_and_slide()

func _on_timer_timeout() -> void:
	stunned = false
	_anim_player.stop()


func _on_death_timer_timeout() -> void:
	queue_free()


func _on_projectile_timer_timeout() -> void:
	can_shoot_projectile = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_being_knocked_back = true
		body.current_health -= damage
		dir = global_position.direction_to(Global.Player.global_position) * -1
		velocity = dir* 2000 * get_physics_process_delta_time()
		knockback_timer.start(0.05)


func _on_knockback_timer_timeout() -> void:
	is_being_knocked_back = false
	dir = global_position.direction_to(Global.Player.global_position)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		is_being_knocked_back = true
		dir = global_position.direction_to(Global.Player.global_position) * -1
		velocity = dir* 2000 * get_physics_process_delta_time()
		knockback_timer.start(0.05)


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_in_player_range = true


func _on_special_attack_timer_timeout() -> void:
	can_use_special_attack = false
	is_using_special_attack = false
	special_attack_cooldown_timer.start(special_attack_cooldown + randf_range(0,3))
	


func _on_special_attack_cooldown_timer_timeout() -> void:
	can_use_special_attack = true


func _on_area_2d_3_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_in_player_range = false
