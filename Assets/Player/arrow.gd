extends Node2D


func _on_destructor_timeout() -> void:
	self.queue_free()
