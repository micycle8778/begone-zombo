extends Node2D

@export_group("Render")
@export var start_color: Color
@export var end_color: Color

@export var glow_time: float
@export var fade_time: float

@export_group("Behavior")
@export var depth: float
@export var damage_gradient: float
@export var angle: float

var clock := 0.0

@onready var glow_polygon = $GlowPolygon
@onready var fade_polygon = $FadePolygon

func modify_polygon(
		polygon: Polygon2D,
		inner_radius: float,
		outer_radius: float,
		background
	):
	var angle_from = -angle / 2
	var angle_to = angle / 2
	var nb_points = 32

	var points = PackedVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points)
		points.push_back(Vector2(cos(angle_point), sin(angle_point)) * inner_radius)

	for i in range(nb_points, -1, -1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points)
		points.push_back(Vector2(cos(angle_point), sin(angle_point)) * outer_radius)
	
	polygon.polygon = points
	
	polygon.texture = null
	if background is Color:
		polygon.color = background
	elif background is Texture2D:
		polygon.texture = background

func _draw():
#	if clock <= glow_time + fade_time:
#		draw_donut_arc((clock / (glow_time + fade_time)) * depth, depth, end_color, true)
#	if clock <= glow_time:
#		draw_donut_arc(clock / glow_time * depth, depth, start_color)
		pass

func _process(delta):
	clock += delta
	
	if clock <= glow_time:
		modify_polygon(glow_polygon, clock / glow_time * depth, depth, start_color)
	elif glow_polygon != null:
		glow_polygon.queue_free()
	
	if clock <= glow_time + fade_time:
		var gradient := Gradient.new()
		gradient.colors = PackedColorArray()
		gradient.offsets = PackedFloat32Array()
		
		gradient.add_point(min(clock / glow_time - fade_time/glow_time, 1), Color.TRANSPARENT)
		gradient.add_point(min(clock / glow_time, 1), end_color)
		
		print(clock / glow_time - glow_time/fade_time, " ", clock / glow_time)
		
		var texture := GradientTexture1D.new()
		texture.gradient = gradient
		
		modify_polygon(
				fade_polygon, 
				0,#(clock / (glow_time + fade_time)) * depth, 
				depth, 
				texture
		)
	else:
		queue_free()

func _ready():
	pass
#	var angle_from = -angle / 2
#	var angle_to = angle / 2
#
#	var points = PackedVector2Array()
#
#	for i in range(nb_points + 1):
#		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points)
#		points.push_back(Vector2(cos(angle_point), sin(angle_point)) * 0)
#
#	for i in range(nb_points + 1, 1, -1):
#		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points)
#		points.push_back(Vector2(cos(angle_point), sin(angle_point)) * depth)
#
#	glow_polygon.polygon = points
	
	#clock += delta
	#queue_redraw()
