extends Node2D

@onready var _spawn_timer = $Timer
@onready var _wave_timer = $wave_timer
@onready var upgrade_menu = $Node2D
@onready var enemies = $enemies
@onready var wave_display =$"../CharacterBody2D/Label2"

@onready var red_basic_timer =$RedBasicTimer
@onready var red_projectile_timer =$RedprojectileTimer
@onready var red_charger_timer =$RedchargerTimer
@onready var red_basic_elite_timer =$RedBasicEliteTimer
@onready var red_projectile_elite_timer =$RedprojectileEliteTimer
@onready var red_hybrid_grunt_timer =$RedhybridgruntTimer
@onready var red_projectile_grunt_timer =$RedprojectilegruntTimer

@onready var yellow_basic_timer = $YellowBasicTimer

@onready var shop_window1 = $Node2D/shop_window/TextureButton
@onready var shop_window2 = $Node2D/shop_window2/TextureButton2
@onready var shop_window3 = $Node2D/shop_window3/TextureButton3

@onready var shop_icon1 =$Node2D/shop_window/Sprite2D
@onready var shop_icon2 =$Node2D/shop_window2/Sprite2D
@onready var shop_icon3 =$Node2D/shop_window3/Sprite2D

@onready var shop_label1 = $Node2D/shop_window/Label
@onready var shop_label2 = $Node2D/shop_window2/Label2
@onready var shop_label3 = $Node2D/shop_window3/Label3
@onready var reroll_label = $Node2D/TextureButton4/Label
var reusable_enemies_scene = preload("res://scenes/enemies.tscn")
var wave_length = 10

var red_basic_spawn_cooldown = 1.0
var red_basic_projectile_spawn_cooldown = 2.0
var red_basic_charger_spawn_cooldown = 3.0
var red_elite_basic_spawn_cooldown = 4.0
var red_elite_projectile_spawn_cooldown = 5.0
var red_hybrid_grunt_spawn_cooldown = 5.0
var red_projectile_grunt_spawn_cooldown = 4

var yellow_basic_spawn_cooldown = 1.0

var current_wave = 1
var rand_enemy

var dumbell_times_bought = 1
var sharpshooter_times_bought = 1
var danis_milk_times_bought = 1

var red_basic = preload("res://scenes/enemies/red/red_basic_enemy.tscn")
var red_basic_projectile = preload("res://scenes/enemies/red/red_projectile_enemy.tscn")
var red_basic_charger = preload("res://scenes/enemies/red/red_charger.tscn")
var red_elite_basic = preload("res://scenes/enemies/red/red_basic_elite.tscn")
var red_elite_projectile = preload("res://scenes/enemies/red/red_elite_projectile.tscn")
var red_hybrid_grunt = preload("res://scenes/enemies/red/red_hybrid.tscn")
var red_projectile_grunt = preload("res://scenes/enemies/red/red_projectile_grunt.tscn")

var yellow_basic = preload("res://resources/yellow_basic.tscn")

var dumbell = preload("res://resources/Dumbell.tscn")
var sharp_shooter = preload("res://resources/sharp_shooter.tscn")
var danis_milk = preload("res://resources/dani's_milk.tscn")

var soldout = preload("res://resources/soldout.tscn")

var shop1_item
var shop2_item
var shop3_item
var shop1_cost
var shop2_cost
var shop3_cost
var reroll_cost = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_wave = 1
	_start_wave(current_wave)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	wave_display.text = str(current_wave)
	$Node2D.global_position = Global.Player.global_position
	reroll_label.text = "Reroll: " + str(reroll_cost)
	Global.current_wave = current_wave
func _on_timer_timeout() -> void:
	_spawn_timer.start(0.1)


func _on_wave_timer_timeout() -> void:
	_stop_wave()


func _start_wave(wave: int):
	if current_wave == 11:
		if get_parent().colour == "red":
			get_tree().change_scene_to_file("res://scenes/classes/yellow.tscn")
	if current_wave != 0 and current_wave != 1:
		Global.Player.current_health = Global.Player.max_health
	if get_parent().colour == "red":
		red_basic_timer.start(red_basic_spawn_cooldown)
		red_projectile_timer.start(red_basic_projectile_spawn_cooldown)
		red_charger_timer.start(red_basic_charger_spawn_cooldown)
		if current_wave < 3:
			red_charger_timer.stop()
		red_basic_elite_timer.start(red_elite_basic_spawn_cooldown)
		if current_wave < 4:
			red_basic_elite_timer.stop()
		red_projectile_elite_timer.start(red_elite_projectile_spawn_cooldown)
		if current_wave < 3:
			red_projectile_elite_timer.stop()
		red_hybrid_grunt_timer.start(red_hybrid_grunt_spawn_cooldown)
		if current_wave < 5:
			red_hybrid_grunt_timer.stop()
		red_projectile_grunt_timer.start(red_projectile_grunt_spawn_cooldown)
		if current_wave < 4:
			red_projectile_grunt_timer.stop()


	elif get_parent().colour == "yellow":
		yellow_basic_timer.start(yellow_basic_spawn_cooldown)
	_wave_timer.start(wave_length)
	$Node2D.hide()
	if shop_icon1.get_child(0) != null:
		shop_icon1.get_child(0).queue_free()
		shop_icon2.get_child(0).queue_free()
		shop_icon3.get_child(0).queue_free()
func _stop_wave():
	
	_wave_timer.stop()
	
	red_basic_spawn_cooldown /= 1.2
	red_basic_projectile_spawn_cooldown /= 1.2
	red_basic_charger_spawn_cooldown /= 1.2
	red_elite_basic_spawn_cooldown /= 1.2
	red_elite_projectile_spawn_cooldown /= 1.2
	red_hybrid_grunt_spawn_cooldown /= 1.2

	Global.Player.current_health = Global.Player.max_health

	red_basic_timer.stop()
	red_projectile_timer.stop()
	red_charger_timer.stop()
	red_basic_elite_timer.stop()
	red_projectile_elite_timer.stop()
	red_hybrid_grunt_timer.stop()
	current_wave += 1
	upgrade_menu.visible = true
	wave_length *=1.3
	_open_shop()
	enemies.queue_free()
	var new_reusable_enemies = reusable_enemies_scene.instantiate()
	enemies = new_reusable_enemies
	add_child(enemies)

func _spawn_enemy(enemy: PackedScene):
	var new_enemy = enemy.instantiate()
	new_enemy.global_position.x = randf_range(-582.819,506.427)
	new_enemy.global_position.y = randf_range(-407.228,591.198)
	enemies.add_child(new_enemy)

#func _choose_enemy():
	#var rand_num
	#if current_wave == 1:
		#rand_num = randi_range(1,2)
	#if current_wave == 2:
		#rand_num = randi_range(1,3)
	#if current_wave == 3:
		#rand_num = randi_range(1,3)
	#if current_wave == 4:
		#rand_num = randi_range(1,4)
	#if current_wave == 5:
		#rand_num = randi_range(1,5)
	#if rand_num == 1:
		#rand_enemy = red_basic
	#if rand_num == 2:
		#rand_enemy = red_basic_projectile
	#if rand_num == 3 and current_wave >= red_basic_charger.instantiate().spawn_wave:
		#rand_enemy = red_basic_charger
	#else:
		#return
	#if rand_num == 4 and current_wave >= red_basic_charger.instantiate().spawn_wave:
		#rand_enemy = red_elite_basic
	#else:
		#return
	#if rand_num == 5 and current_wave >= red_basic_charger.instantiate().spawn_wave:
		#rand_enemy = red_elite_projectile
	#else:
		#return





func _on_texture_button_2_button_up() -> void:
	if Global.Player.money >= shop2_cost:
		Global.Player._upgrades.add_child(shop2_item.instantiate())
		Global.Player.money -= shop2_cost
		if shop2_item == dumbell:
			dumbell_times_bought +=1
		if shop2_item == sharp_shooter:
			sharpshooter_times_bought +=1
		if shop3_item == danis_milk:
			danis_milk_times_bought +=1
		shop2_item = soldout.instantiate()
		shop2_cost = 99999999999999999999
		shop_icon2.get_child(0).queue_free()
		shop_icon2.add_child(soldout.instantiate())
func _on_red_basic_timer_timeout() -> void:
	_spawn_enemy(red_basic)
	red_basic_timer.start(1)

func _on_redprojectile_timer_timeout() -> void:
	_spawn_enemy(red_basic_projectile)
	red_projectile_timer.start(1.2)
func _on_redcharger_timer_timeout() -> void:
	_spawn_enemy(red_basic_charger)
	red_charger_timer.start(3)

func _on_red_basic_elite_timer_timeout() -> void:
	_spawn_enemy(red_elite_basic)
	red_basic_elite_timer.start(3.5)

func _on_redprojectile_elite_timer_timeout() -> void:
	_spawn_enemy(red_elite_projectile)
	red_projectile_elite_timer.start(3.2)


func _open_shop():
	if shop_icon1.get_child(0) != null:
		shop_icon1.get_child(0).queue_free()
		shop_icon2.get_child(0).queue_free()
		shop_icon3.get_child(0).queue_free()
	var rand_upgrade1 = randi_range(1,3)
	if rand_upgrade1 == 1:
		shop_icon1.add_child(dumbell.instantiate())
		shop1_item = dumbell
		shop1_cost = 20
		shop1_cost *= (dumbell_times_bought * 0.3)
		round(shop1_cost)
		shop_label1.text = str(shop1_cost)
	if rand_upgrade1 == 2:
		shop_icon1.add_child(sharp_shooter.instantiate())
		shop1_item = sharp_shooter
		shop1_cost = 15
		shop1_cost *= (sharpshooter_times_bought * 0.3)
		round(shop1_cost)
		shop_label1.text = str(shop1_cost)
	if rand_upgrade1 == 3:
		shop_icon1.add_child(danis_milk.instantiate())
		shop1_item = danis_milk
		shop1_cost = 10
		shop1_cost *= (danis_milk_times_bought * 0.3)
		round(shop1_cost)
		shop_label1.text = str(shop1_cost)
	var rand_upgrade2 = randi_range(1,3)
	if rand_upgrade2 == 1:
		shop_icon2.add_child(dumbell.instantiate())
		shop2_item = dumbell
		shop2_cost = 20
		shop2_cost *= (dumbell_times_bought * 0.3)
		round(shop2_cost)
		shop_label2.text = str(shop2_cost)
	if rand_upgrade2 == 2:
		shop_icon2.add_child(sharp_shooter.instantiate())
		shop2_item = sharp_shooter
		shop2_cost = 15
		shop2_cost *= (sharpshooter_times_bought * 0.3)
		round(shop2_cost)
		shop_label2.text = str(shop2_cost)
	if rand_upgrade2 == 3:
		shop_icon2.add_child(danis_milk.instantiate())
		shop2_item = danis_milk
		shop2_cost = 15
		shop2_cost *= (danis_milk_times_bought * 0.3)
		round(shop2_cost)
		shop_label2.text = str(shop2_cost)
	var rand_upgrade3 = randi_range(1,3)
	if rand_upgrade3 == 1:
		shop_icon3.add_child(dumbell.instantiate())
		shop3_item = dumbell
		shop3_cost = 20
		shop3_cost *= (dumbell_times_bought * 0.3)
		round(shop3_cost)
		shop_label3.text = str(shop3_cost)
	if rand_upgrade3 == 2:
		shop_icon3.add_child(sharp_shooter.instantiate())
		shop3_item = sharp_shooter
		shop3_cost = 15
		shop3_cost *= (sharpshooter_times_bought * 0.3)
		round(shop3_cost)
		shop_label3.text = str(shop3_cost)
	if rand_upgrade3 == 3:
		shop_icon3.add_child(danis_milk.instantiate())
		shop3_item = danis_milk
		shop3_cost = 10
		shop3_cost *= (danis_milk_times_bought * 0.3)
		round(shop3_cost)
		shop_label3.text = str(shop3_cost)


func _on_texture_button_button_up() -> void:
	if Global.Player.money >= shop1_cost:
		Global.Player._upgrades.add_child(shop1_item.instantiate())
		Global.Player.money -= shop1_cost
		if shop1_item == dumbell:
			dumbell_times_bought +=1
		if shop1_item == sharp_shooter:
			sharpshooter_times_bought +=1
		if shop1_item == danis_milk:
			danis_milk_times_bought +=1
		shop1_item = soldout.instantiate()
		shop1_cost = 99999999999999999999
		shop_icon1.get_child(0).queue_free()
		shop_icon1.add_child(soldout.instantiate())

func _on_texture_button_3_button_up() -> void:
	if Global.Player.money >= shop3_cost:
		Global.Player._upgrades.add_child(shop3_item.instantiate())
		Global.Player.money -= shop3_cost
		if shop3_item == dumbell:
			dumbell_times_bought +=1
		if shop3_item == sharp_shooter:
			sharpshooter_times_bought +=1
		if shop3_item == danis_milk:
			danis_milk_times_bought +=1
		shop3_item = soldout.instantiate()
		shop3_cost = 99999999999999999999
		shop_icon3.get_child(0).queue_free()
		shop_icon3.add_child(soldout.instantiate())


func _on_texture_button_5_button_up() -> void:
	_start_wave(current_wave + 1)


func _on_texture_button_4_button_up() -> void:
	if Global.Player.money >= reroll_cost:
		_open_shop()
		Global.Player.money -= reroll_cost
		reroll_cost *= 2


func _on_redhybridgrunt_timer_timeout() -> void:
	_spawn_enemy(red_hybrid_grunt)
	red_hybrid_grunt_timer.start(4)


func _on_redprojectilegrunt_timer_timeout() -> void:
	_spawn_enemy(red_projectile_grunt)
	red_projectile_grunt_timer.start(4)


func _on_yellow_basic_timer_timeout() -> void:
	_spawn_enemy(yellow_basic)
	yellow_basic_timer.start(1)
