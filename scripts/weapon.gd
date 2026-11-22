extends Area2D

enum WEAPONTYPE {ranged,melee}
enum SUBCLASS {gun,throw,melee,support,sword}

var projectile_dir

var current_weapon:weapon_resource
@onready var _sprite = $Sprite2D
@onready var main = get_tree().get_root()
@onready var _raycast = $RayCast2D
@onready var _attack_cooldown_timer = $attack_cooldown_timer
@onready var _anim_player = $AnimationPlayer
@onready var _audio_player = $AudioStreamPlayer2D

var projectiles_spawned = 0

var can_attack = true
var bullet = preload("res://scenes/bullet.tscn")
var weapon_name:String
var damage:int
var pierce:int
var cooldown:float
var speed:float
var projectile_amount:int
var projectile_spread:float
var projectile_lifetime:float
var weapon_type
var subclass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_weapon = Global.player_class.starting_weapon
	weapon_name = current_weapon.weapon_name
	_sprite = current_weapon._texture
	damage = current_weapon.damage
	pierce = current_weapon.pierce
	cooldown = current_weapon.cooldown
	speed = current_weapon.speed
	projectile_amount = current_weapon.projectile_amount
	projectile_spread = current_weapon.projectile_spread
	projectile_lifetime = current_weapon.projectile_lifetime
	weapon_type = current_weapon.weapon_type
	subclass = current_weapon.subclass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_raycast.target_position = to_local(get_global_mouse_position()) * 10000000000
	current_weapon = Global.player_class.starting_weapon
	if Input.is_action_pressed("attack") and can_attack == true:
		can_attack = false
		if projectile_amount == 1:
			var new_projectile = bullet.instantiate()
			new_projectile.lifetime = projectile_lifetime
			new_projectile.speed = speed
			new_projectile.spawnpos = global_position
			new_projectile.damage = damage
			can_attack = false
			_attack_cooldown_timer.start(cooldown)
			main.add_child(new_projectile)
			_audio_player.play()
		elif projectile_amount == 2:
			for i in projectile_amount:
				projectiles_spawned +=1
				var new_projectile = bullet.instantiate()
				new_projectile.lifetime = projectile_lifetime
				new_projectile.speed = speed
				new_projectile.spawnpos = global_position
				if projectiles_spawned == 1:
					new_projectile.spawnrot = projectile_spread
				if projectiles_spawned == 2:
					new_projectile.spawnrot = projectile_spread * -1
				new_projectile.damage = damage
				can_attack = false
				_attack_cooldown_timer.start(cooldown)
				main.add_child(new_projectile)
			_audio_player.play()
			projectiles_spawned = 0
		elif projectile_amount == 3:
			for i in projectile_amount:
				projectiles_spawned +=1
				var new_projectile = bullet.instantiate()
				new_projectile.lifetime = projectile_lifetime
				new_projectile.speed = speed
				new_projectile.spawnpos = global_position
				if projectiles_spawned == 1:
					new_projectile.spawnrot = projectile_spread
				if projectiles_spawned == 2:
					new_projectile.spawnrot = projectile_spread * -1
				if projectiles_spawned == 3:
					new_projectile.spawnrot = 0
				new_projectile.damage = damage
				can_attack = false
				_attack_cooldown_timer.start()
				main.add_child(new_projectile)
			_audio_player.play(global_position)
			projectiles_spawned = 0
		elif projectile_amount == 4:
			for i in projectile_amount:
				projectiles_spawned +=1
				var new_projectile = bullet.instantiate()
				new_projectile.lifetime = projectile_lifetime
				new_projectile.speed = speed
				new_projectile.spawnpos = global_position
				if projectiles_spawned == 1:
					new_projectile.spawnrot = projectile_spread
				if projectiles_spawned == 2:
					new_projectile.spawnrot = projectile_spread *2
				if projectiles_spawned == 3:
					new_projectile.spawnrot = projectile_spread * -1
				if projectiles_spawned == 4:
					new_projectile.spawnrot = 0
				new_projectile.damage = damage
				can_attack = false
				_attack_cooldown_timer.start()
				main.add_child(new_projectile)
			_audio_player.play()
			projectiles_spawned = 0


func _on_attack_cooldown_timer_timeout() -> void:
	can_attack = true
