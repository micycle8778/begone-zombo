extends CharacterBody2D
class_name Player

const max_speed = 150
const walk_force = 300
const friction = 5.6

var pickups: Array[WeaponPickup] = []
var weapon: Weapon = null

func _input(_event):
	if Input.is_action_just_pressed("pick_up") and len(pickups) != 0:
		if weapon != null:
			weapon.queue_free()
			
		var pickup: WeaponPickup = pickups.pop_back()
		
		weapon = pickup.weapon
		weapon.reparent(self)
		weapon.position = Vector2(0,0)
		pickup.queue_free()

func _physics_process(delta):
	var acceleration = Vector2(0,0)
	
	if Input.is_action_pressed("move_up"):
		acceleration.y -= walk_force
	if Input.is_action_pressed("move_down"):
		acceleration.y += walk_force
	if Input.is_action_pressed("move_left"):
		acceleration.x -= walk_force
	if Input.is_action_pressed("move_right"):
		acceleration.x += walk_force
	
	if acceleration == Vector2(0,0):
		velocity -= (velocity * friction * delta)
	else:
		velocity += acceleration * delta
	
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	
	move_and_slide()

func _process(_delta):
	if weapon != null:
		if weapon.full_auto and Input.is_action_pressed("shoot"):
			weapon.fire(get_parent())
		if not weapon.full_auto and Input.is_action_just_pressed("shoot"):
			weapon.fire(get_parent())
	
		weapon.look_at(get_global_mouse_position())
