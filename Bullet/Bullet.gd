extends Node2D

@export_group("Render")
@export var start_color: Color
@export var end_color: Color
@export var thickness := 2.0

@export var glow_time := 0.1
@export var fade_time := 0.25

@export_group("Behavior")
@export var rotation_variance := 0.0

@onready var glow_timer = $GlowTimer

var length = 10000

func _draw():
	draw_line(
		Vector2(0, thickness / 2),
		Vector2(length, -thickness / 2),
		start_color if not glow_timer.is_stopped() else end_color,
		2,
		true
	)

func _ready():
	# randomly adjust rotation
	rotation_degrees += randf_range(-rotation_variance, rotation_variance)
	
	# setup glow time
	glow_timer.wait_time = glow_time
	glow_timer.start()
	
	# cast the ray
	var space = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		Vector2(0,0),
		Vector2(1, 0).rotated(rotation) * 10000,
	)
	
	var result = space.intersect_ray(query)

func _on_decay_timer_timeout():
	queue_redraw()
	
	var tween = create_tween()
	tween.tween_property(
		self, 
		"modulate", 
		Color.TRANSPARENT, 
		fade_time
	)
	
	await tween.finished
	queue_free()
