extends RigidBody2D

@export var speed : float = 200;
@export var damage : float = 10;

func setPosition(position : Vector2) -> void:
	self.global_position = position

func setDirection(direction : Vector2) -> void:
	linear_velocity = direction * speed
	rotation = direction.angle()

func _on_destructor_timeout() -> void:
	self.queue_free()
