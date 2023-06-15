@tool
extends Area2D
class_name WeaponPickup

@export var weapon_scene: CustomizablePackedScene:
	set(value):
		weapon_scene = value
		queue_redraw()

@onready var weapon: Weapon = weapon_scene.instantiate()

func _ready():
	add_child(weapon)

func _on_Player_entered(player: Player):
	if player:
		player.pickups.append(self)

func _on_Player_exited(player: Player):
	if player:
		player.pickups.pop_at(player.pickups.find(self))
