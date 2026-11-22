extends Area2D

@onready var _lifetime_timer = $Timer

var speed = 1
var dir:Vector2
var pierce = 1
var pierce_left = 1
var spawnrot:float
var spawnpos:Vector2
var damage:float
var lifetime:float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = spawnpos
	global_rotation_degrees = spawnrot
	look_at(get_global_mouse_position())
	rotation_degrees += spawnrot
	_lifetime_timer.start(lifetime)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * speed * delta

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	if pierce_left <= 0:
		queue_free()

#func _on_body_entered(body: Node2D) -> void:
	#if body.is_in_group("player"):
		#return
	#if body.is_in_group("enemy"):
		#if body.defense >= Global.Player.weapon.damage:
			#body.current_health -= Global.Player.weapon.damage - body.defense
		#else:
			#body.current_health -= 1
		#body._anim_player.stop()
		#body.hit = true
		#pierce_left -= 1
	#if body.is_in_group("enemy"):
		#pierce_left -=1
	#elif !body.is_in_group("player"):
		#queue_free()


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
		pierce_left -=1
	elif !area.is_in_group("player"):
		pass


func _on_timer_timeout() -> void:
	queue_free()
