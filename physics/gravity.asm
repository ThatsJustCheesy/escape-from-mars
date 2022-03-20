## typedef struct physics_state {
## 	int y_velocity;
##	int y_acceleration;
##	int tick_counter;
## 	int on_ground;
## } physics_state;

.eqv SIZEOF_physics_state 16

.eqv physics_state.y_velocity 0
.eqv physics_state.y_acceleration 4
.eqv physics_state.tick_counter 8
.eqv physics_state.on_ground 12

.text

## void apply_gravity(object* obj, physics_state* physics)
## Apply gravity to `obj`, given its current physics state `physics`,
## by updating `obj`'s position and physics state as necessary.
apply_gravity:
	lw $t1, object.y($a0)
	lw $t2, physics_state.y_velocity($a1)
	lw $t3, physics_state.y_acceleration($a1)
	lw $t4, physics_state.on_ground($a1)
	
apply_gravity_check_on_ground_1:
	beq $t1, BOTTOM_WALL_Y, apply_gravity_on_ground_1
	
	# on_ground = 0
	li $t4, 0
	
	j apply_gravity_tick_check
	
apply_gravity_on_ground_1:
	# on_ground = 1
	li $t4, 1

apply_gravity_tick_check:
	# Increment phycics.tick
	# If < GRAVITY_TICK_RATE, bail
	# If = GRAVITY_TICK_RATE, reset to 0 and continue
	lw $t0, physics_state.tick_counter($a1)
	addi $t0, $t0, 1
	sw $t0, physics_state.tick_counter($a1)
	blt $t0, GRAVITY_TICK_RATE, apply_gravity_return
	move $t0, $zero
	sw $t0, physics_state.tick_counter($a1)
	
apply_gravity_passed_tick_check:
	beq $t1, BOTTOM_WALL_Y, apply_gravity_no_gravity
	
	# Add y acceleration to y velocity
	add $t2, $t2, $t3
	
apply_gravity_no_gravity:
	# Add y velocity to y pos
	add $t1, $t1, $t2

apply_gravity_check_on_ground_2:
	beq $t1, BOTTOM_WALL_Y, apply_gravity_on_ground_2

	# on_ground = 0
	li $t4, 0

	j apply_gravity_fix_y_1

apply_gravity_on_ground_2:
	# on_ground = 1
	li $t4, 1
	
apply_gravity_fix_y_1:
	bge $t1, TOP_WALL_Y, apply_gravity_fix_y_2
	li $t1, TOP_WALL_Y	# Top edge
	addi $t1, $t1, -1
	li $t2, 2
	j apply_gravity_return

apply_gravity_fix_y_2:
	ble $t1, BOTTOM_WALL_Y, apply_gravity_return
	li $t1, BOTTOM_WALL_Y	# Bottom edge
	li $t2, 0
	li $t4, 1

	# ## DEBUGGING
	# move $t9, $a0
	# li $v0, PRINT_INTEGER
	# move $a0, $t4
	# syscall
	# li $v0, PRINT_STRING
	# la $a0, newline
	# syscall
	# move $a0, $t9
	# ## END
	
apply_gravity_return:
	sw $t1, object.y($a0)
	sw $t2, physics_state.y_velocity($a1)
	sw $t3, physics_state.y_acceleration($a1)
	sw $t4, physics_state.on_ground($a1)
	
	jr $ra
