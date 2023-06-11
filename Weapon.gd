extends Node2D
class_name Weapon

@export var fire_rate: float
@export var full_auto: bool
@export var bullet_scene: PackedScene

var can_fire := true

@onready var bullet_spawn_position: Marker2D = $BulletSpawnLocation
@onready var fire_timer: Timer = $FireTimer

func _ready():
	fire_timer.wait_time = 60.0 / fire_rate

func fire(bullet_parent: Node):
	if can_fire:
		can_fire = false
		fire_timer.start()
		
		var bullet = bullet_scene.instantiate()
		
		bullet.global_position = bullet_spawn_position.global_position
		bullet.global_rotation = global_rotation
		
		bullet_parent.add_child(bullet)
		
		fire_timer.start()

func _on_fire_timer_timeout():
	can_fire = true
