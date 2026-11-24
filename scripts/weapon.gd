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

var target_pos = Vector2.ZERO
var h_dir = "left"

var can_attack = true
var is_attacking = false
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
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_raycast.target_position = to_local(get_global_mouse_position()) * 10000000000
	current_weapon = Global.player_class.starting_weapon
	weapon_name = current_weapon.weapon_name
	_sprite.texture = current_weapon._texture
	damage = current_weapon.damage
	pierce = current_weapon.pierce
	cooldown = current_weapon.cooldown
	speed = current_weapon.speed
	projectile_amount = current_weapon.projectile_amount
	projectile_spread = current_weapon.projectile_spread
	projectile_lifetime = current_weapon.projectile_lifetime
	weapon_type = current_weapon.weapon_type
	subclass = current_weapon.subclass
	if current_weapon.weapon_type == WEAPONTYPE.ranged:
		_sprite.offset.x = 3
		_sprite.offset.y = -1
	else:
		if h_dir == "right":
			_sprite.offset.x = 0
			_sprite.offset.y = -8
		else:
			_sprite.offset.x = 0
			_sprite.offset.y = 8
	if Input.is_action_pressed("attack") and can_attack == true and weapon_type == WEAPONTYPE.ranged:
		can_attack = false
		is_attacking = true
		if projectile_amount == 1:
			var new_projectile = bullet.instantiate()
			new_projectile.lifetime = projectile_lifetime
			new_projectile.speed = speed
			new_projectile.spawnpos = global_position
			new_projectile.damage = damage
			new_projectile.pierce = pierce
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
				new_projectile.damage = damage
				new_projectile.pierce = pierce
				if projectiles_spawned == 1:
					new_projectile.spawnrot = projectile_spread
				if projectiles_spawned == 2:
					new_projectile.spawnrot = projectile_spread * -1
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
				new_projectile.pierce = pierce
				new_projectile.damage = damage
				if projectiles_spawned == 1:
					new_projectile.spawnrot = projectile_spread
				if projectiles_spawned == 2:
					new_projectile.spawnrot = projectile_spread * -1
				if projectiles_spawned == 3:
					new_projectile.spawnrot = 0
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
				new_projectile.pierce = pierce
				new_projectile.damage = damage
				if projectiles_spawned == 1:
					new_projectile.spawnrot = projectile_spread
				if projectiles_spawned == 2:
					new_projectile.spawnrot = projectile_spread *2
				if projectiles_spawned == 3:
					new_projectile.spawnrot = projectile_spread * -1
				if projectiles_spawned == 4:
					new_projectile.spawnrot = 0
				can_attack = false
				_attack_cooldown_timer.start()
				main.add_child(new_projectile)
			_audio_player.play()
			projectiles_spawned = 0
			target_pos = get_global_mouse_position()
			look_at(get_global_mouse_position())
	elif Input.is_action_pressed("attack") and can_attack == true and weapon_type == WEAPONTYPE.melee:
		can_attack = false
		is_attacking = true
		_attack_cooldown_timer.start()
		if h_dir == "left":
			_anim_player.play("melee_attack_right")
		else:
			_anim_player.play("melee_attack")
	if is_attacking == false:
		pass
	target_pos = get_global_mouse_position()

func _on_attack_cooldown_timer_timeout() -> void:
	can_attack = true
	is_attacking = false


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		return
	if area.is_in_group("enemy"):
		if area.owner.defense <= Global.Player.weapon.damage:
			area.owner.current_health -= Global.Player.weapon.damage - area.owner.defense
		else:
			area.owner.current_health -= 1
		area.owner._anim_player.stop()
		area.owner.hit = true
	elif !area.is_in_group("player"):
		pass
