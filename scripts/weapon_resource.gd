extends Resource
class_name weapon_resource
enum WEAPONTYPE {ranged,melee}
enum SUBCLASS {gun,throw,melee,support,sword}
@export var weapon_name:String
@export var _texture:CompressedTexture2D
@export var damage:int
@export var pierce:int
@export var cooldown:float
@export var speed:float
@export var projectile_amount:int
@export var projectile_spread:float
@export var projectile_lifetime:float
@export var weapon_type:WEAPONTYPE
@export var subclass:SUBCLASS
