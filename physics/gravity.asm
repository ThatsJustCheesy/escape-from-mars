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
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	
	move $s0, $a0
	move $s1, $a1
	
	lw $t1, object.y($s0)
	lw $t2, physics_state.y_velocity($s1)
	lw $t3, physics_state.y_acceleration($s1)
	lw $t4, physics_state.on_ground($s1)
	
apply_gravity_check_on_ground_1:
	sw $t1, object.y($s0)
	sw $t2, physics_state.y_velocity($s1)
	sw $t3, physics_state.y_acceleration($s1)
	sw $t4, physics_state.on_ground($s1)
	
	lw $t9, object.sprite($s0)
	lw $t9, sprite.height($t9)
	add $t1, $t1, $t9
	sw $t1, object.bounds.y1($s0)
	sub $t1, $t1, $t9
	
	addi $sp, $sp, -16
	sw $t1, 0($sp)
	sw $t2, 4($sp)
	sw $t3, 8($sp)
	sw $t4, 12($sp)
	
	la $a0, level_0
	addi $a1, $s0, object.bounds
	li $a2, 1
	jal check_bottom_collision
	
	lw $t4, 12($sp)
	lw $t3, 8($sp)
	lw $t2, 4($sp)
	lw $t1, 0($sp)
	addi $sp, $sp, 16
	
	# v0 = whether tile below has collision
	bnez $v0, apply_gravity_on_ground_1
	
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
	lw $t0, physics_state.tick_counter($s1)
	addi $t0, $t0, 1
	sw $t0, physics_state.tick_counter($s1)
	blt $t0, GRAVITY_TICK_RATE, apply_gravity_return
	move $t0, $zero
	sw $t0, physics_state.tick_counter($s1)
	
apply_gravity_passed_tick_check:
	sw $t1, object.y($s0)
	sw $t2, physics_state.y_velocity($s1)
	sw $t3, physics_state.y_acceleration($s1)
	sw $t4, physics_state.on_ground($s1)
	
	lw $t9, object.sprite($s0)
	lw $t9, sprite.height($t9)
	add $t1, $t1, $t9
	sw $t1, object.bounds.y1($s0)
	sub $t1, $t1, $t9
	
	addi $sp, $sp, -16
	sw $t1, 0($sp)
	sw $t2, 4($sp)
	sw $t3, 8($sp)
	sw $t4, 12($sp)
	
	la $a0, level_0
	addi $a1, $s0, object.bounds
	li $a2, 1
	jal check_bottom_collision
	
	lw $t4, 12($sp)
	lw $t3, 8($sp)
	lw $t2, 4($sp)
	lw $t1, 0($sp)
	addi $sp, $sp, 16
	
	# v0 = whether tile below has collision
	bnez $v0, apply_gravity_no_gravity
	
	# Add y acceleration to y velocity
	add $t2, $t2, $t3
	
apply_gravity_no_gravity:
	# Add y velocity to y pos
	add $t1, $t1, $t2

apply_gravity_check_on_ground_2:
	sw $t1, object.y($s0)
	sw $t2, physics_state.y_velocity($s1)
	sw $t3, physics_state.y_acceleration($s1)
	sw $t4, physics_state.on_ground($s1)
	
	lw $t9, object.sprite($s0)
	lw $t9, sprite.height($t9)
	add $t1, $t1, $t9
	sw $t1, object.bounds.y1($s0)
	sub $t1, $t1, $t9
	
	addi $sp, $sp, -16
	sw $t1, 0($sp)
	sw $t2, 4($sp)
	sw $t3, 8($sp)
	sw $t4, 12($sp)
	
	la $a0, level_0
	addi $a1, $s0, object.bounds
	li $a2, 1
	jal check_bottom_collision
	
	lw $t4, 12($sp)
	lw $t3, 8($sp)
	lw $t2, 4($sp)
	lw $t1, 0($sp)
	addi $sp, $sp, 16
	
	# v0 = whether tile below has collision
	bnez $v0, apply_gravity_on_ground_2

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
	sw $t1, object.y($s0)
	sw $t2, physics_state.y_velocity($s1)
	sw $t3, physics_state.y_acceleration($s1)
	sw $t4, physics_state.on_ground($s1)
	
	lw $t9, object.sprite($s0)
	lw $t9, sprite.height($t9)
	add $t1, $t1, $t9
	sw $t1, object.bounds.y1($s0)
	sub $t1, $t1, $t9
	
	addi $sp, $sp, -16
	sw $t1, 0($sp)
	sw $t2, 4($sp)
	sw $t3, 8($sp)
	sw $t4, 12($sp)
	
	la $a0, level_0
	addi $a1, $s0, object.bounds
	li $a2, 0
	jal check_bottom_collision
	
	lw $t4, 12($sp)
	lw $t3, 8($sp)
	lw $t2, 4($sp)
	lw $t1, 0($sp)
	addi $sp, $sp, 16
	
	# v0 = whether tile below has collision
	beqz $v0, apply_gravity_return
	
	# Move up by one unit...
	addi $t1, $t1, -1
	
	lw $t9, object.sprite($s0)
	lw $t9, sprite.height($t9)
	add $t1, $t1, $t9
	sw $t1, object.bounds.y1($s0)
	sub $t1, $t1, $t9
	
	li $t2, 0
	li $t4, 1
	
	# ...repeatedly
	j apply_gravity_fix_y_2
	
apply_gravity_return:
	sw $t1, object.y($s0)
	sw $t2, physics_state.y_velocity($s1)
	sw $t3, physics_state.y_acceleration($s1)
	sw $t4, physics_state.on_ground($s1)
	
	lw $t9, object.sprite($s0)
	lw $t9, sprite.height($t9)
	add $t1, $t1, $t9
	sw $t1, object.bounds.y1($s0)
	sub $t1, $t1, $t9
	
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	
	jr $ra
