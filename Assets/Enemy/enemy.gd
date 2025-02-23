extends CharacterBody2D

var movementSpeed: float = 200.0
var movementTargetPosition: Vector2 = Vector2(60.0,180.0)

func _ready() -> void:
	$NavAgent.path_desired_distance = 4
	$NavAgent.target_desired_distance = 4
	
	actorSetup()

	
func actorSetup() -> void:
	await get_tree().physics_frame
	print("Enemy Actor Setup Starting")
	setMovementTarget(movementTargetPosition)
	
func setMovementTarget(movementTargetPosition) ->  void:
	$NavAgent.target_position = movementTargetPosition

func _physics_process(delta: float) -> void:
	if $NavAgent.is_navigation_finished():
		return
		
	var currentAgentPosition : Vector2 = global_position
	var nextPathPosition : Vector2 = $NavAgent.get_next_path_position()
	
	velocity = currentAgentPosition.direction_to(nextPathPosition) * movementSpeed
	move_and_slide()
