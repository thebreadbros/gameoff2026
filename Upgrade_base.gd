extends Node2D
@export var _sprite:Sprite2D
@export var upgrade:Upgrade_Resource
var _texture:Texture2D
var pierce_buff:int
var damage_buff:int
var cooldown_buff:float
var speed_buff:float
var projectile_amount_buff:int
var projectile_speed_buff:float
var health_buff:int
var cost:int
# Called when the node enters the scene tree for the first time.
func _enter_tree()-> void:
	_texture = upgrade.texture
	damage_buff = upgrade.damage_buff
	speed_buff = upgrade.speed_buff
	projectile_amount_buff = upgrade.speed_buff
	projectile_speed_buff = upgrade.projectile_speed_buff
	health_buff = upgrade.health_buff
	cost = upgrade.cost
	_sprite.texture = upgrade.texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _is_relic():
	return true
