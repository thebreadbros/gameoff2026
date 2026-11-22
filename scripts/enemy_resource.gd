extends Resource
class_name enemy_resource

enum ENEMY_COLOUR {RED,GREEN,YELLOW,BLUE,PURPLE,GREY,ORANGE,MONOCHROME}
enum ENEMY_TYPE {BASIC,CHARGER,RUNNER,PASSIVE}

@export var _name:String
@export var colour:ENEMY_COLOUR
@export var type:ENEMY_TYPE
@export var max_health:int
@export var speed:float
@export var damage:float
@export var special_attack:bool
@export var special_attack_cooldown:float
@export var defense:int
@export var projectiles:bool
@export var projectile_speed:float
@export var proj_1_angle:float
@export var proj_2_angle:float
@export var proj_3_angle:float
@export var proj_4_angle:float
@export var projectile_amount:int
@export var projectile_cooldown:float
@export var projectile_scene:PackedScene
@export var value:int
@export var difficulty_scale:Curve
@export var spawn_wave:int
