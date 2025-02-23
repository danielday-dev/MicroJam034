extends Node
class_name ProjectileList

static var s_projectileList : Node = null

func _ready() -> void:
	s_projectileList = self
	

static func addProjectile(projectile) -> void:
	if s_projectileList == null:
		return
	s_projectileList.add_child(projectile)
