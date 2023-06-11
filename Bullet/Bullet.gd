extends Node2D

@export var start_color: Color
@export var end_color: Color

@onready var lifetime_timer = $LifetimeTimer
@onready var decay_timer = $DecayTimer

func _draw():
	draw_line(
		Vector2(0,1),
		Vector2(10000, -1),
		start_color if not decay_timer.is_stopped() else end_color,
		2,
		true
	)

func _ready():
	# cast the ray
	var space = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		Vector2(0,0),
		Vector2(1, 0).rotated(rotation) * 10000,
	)
	
	var result = space.intersect_ray(query)

func _on_lifetime_timer_timeout():
	queue_free()

func _on_decay_timer_timeout():
	queue_redraw()
