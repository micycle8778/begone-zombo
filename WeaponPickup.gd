extends Area2D
class_name WeaponPickup

@export var weapon_scene: PackedScene
@onready var weapon: Weapon = weapon_scene.instantiate()

func _ready():
	add_child(weapon)


func _on_Player_entered(player: Player):
	if player:
		player.pickups.append(self)


func _on_Player_exited(player: Player):
	if player:
		player.pickups.pop_at(player.pickups.find(self))
