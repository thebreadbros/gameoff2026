extends Area2D
var dir:Vector2
var speed:float
var spawnpos:Vector2
var spawnrot:float
var damage:float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = spawnpos
	global_rotation_degrees = spawnrot
	look_at(Global.Player.global_position)
	rotation_degrees += spawnrot


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.current_health -= damage
		queue_free()
