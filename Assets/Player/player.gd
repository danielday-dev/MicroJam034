extends CharacterBody2D


var movementSpeed: float = 200.0
var movementTargetPosition: Vector2 = Vector2(400.0,180.0)
var attackPrepared : bool = false
var currentAttackTarget : Vector2 = Vector2.ZERO
var arrow = load("res://Assets/Player/arrow.tscn")


func _ready() -> void:
	$NavAgent.path_desired_distance = 4
	$NavAgent.target_desired_distance = 4
	
	actorSetup()
	
	

func actorSetup() -> void:
	await get_tree().physics_frame
	print("Enemy Actor Setup Starting")
	setMovementTarget(movementTargetPosition)
	
func setMovementTarget(movementTargetPosition) -> void:
	$NavAgent.target_position = movementTargetPosition

func _physics_process(delta: float) -> void:
	# check for click input
	if Input.is_action_just_released("right_click"):
		
		setMovementTarget(get_global_mouse_position())
	
	if $NavAgent.is_navigation_finished():
		if attackPrepared:
			chooseTarget()
			if currentAttackTarget != Vector2.ZERO:
				shootArrow()
		return
		
	var currentAgentPosition : Vector2 = global_position
	var nextPathPosition : Vector2 = $NavAgent.get_next_path_position()
	
	velocity = currentAgentPosition.direction_to(nextPathPosition) * movementSpeed
	move_and_slide()

func chooseTarget() -> void:
	# function to pick closest enemy to player and store its location
	# searches area around player for node type "enemy"
	# if no targets, then sets to zero
	var minimumDistance : float = $AttackRange/Range.shape.radius
	var checkval : float = minimumDistance
	for enemy : Node2D in enemies:
		var distanceToEnemy = self.global_position.distance_to(enemy.global_position)
		if distanceToEnemy < minimumDistance:
			minimumDistance = distanceToEnemy
			currentAttackTarget = enemy.global_position
	
	if checkval == minimumDistance:
		currentAttackTarget = Vector2.ZERO
	return
	
func shootArrow() -> void:
	# shoots an arrow in the direction of the target
	var arrowInstance = arrow.instantiate()
	ProjectileList.addProjectile(arrowInstance) #WARNING Small coupling issue but is cleanish solution
	var directionToEnemy : Vector2 = self.global_position.direction_to(currentAttackTarget)
	arrowInstance.setPosition(self.global_position)
	arrowInstance.setDirection(directionToEnemy)
	attackPrepared = false
	$AttackTimer.start()


func _on_attack_timer_timeout() -> void:
	attackPrepared = true;

var enemies : Dictionary = {}
func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"): 
		enemies[body] = null
		
func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"): 
		if enemies.has(body):
			enemies.erase(body)
