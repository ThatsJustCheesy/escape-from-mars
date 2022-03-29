## typedef struct player {
## 	object obj;
## 	physics_state physics;
## } player;

.eqv SIZEOF_player 40 # SIZEOF_object + SIZEOF_physics_state

.eqv player.obj.x 0
.eqv player.obj.bounds.x0 0
.eqv player.obj.y 4
.eqv player.obj.bounds.y0 4
.eqv player.obj.bounds.x1 8
.eqv player.obj.bounds.y1 12
.eqv player.obj.sprite 16
.eqv player.obj.update 20
.eqv player.physics 24
.eqv player.physics.y_velocity 24
.eqv player.physics.y_acceleration 28
.eqv player.physics.tick_counter 32
.eqv player.physics.on_ground 36

.eqv PLAYER_X_SPEED 5
.eqv PLAYER_JUMP_Y_SPEED 6
.eqv PLAYER_Y_ACCELERATION_DUE_TO_GRAVITY 1

.include "realplayer.asm"
.include "scriptedplayer.asm"

.data
player_x_velocity:	.word 0

.text

## void update_player(object* self)
## Update function for player objects.
update_player:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $t7, $a0
	lw $t0, player.obj.x($t7)
	lw $t1, player.obj.y($t7)
	lw $t2, player_x_velocity
	lw $t3, player.physics.y_velocity($t7)
	lw $t4, player.physics.y_acceleration($t7)
	
	lw $t5, player.physics.on_ground($t7)
	beqz $t5, update_player_not_on_ground

update_player_on_ground:
	# Apply horizonal friction
	# constant * -sign(x_velocity)
	move $a0, $t2
	jal sign		# take sign of x_velocity
	sub $v0, $zero, $v0	# negate
	li $t9, 1
	mul $t9, $t9, $v0	# multiply by constant
	add $t2, $t2, $t9	# apply friction
	sw $t2, player_x_velocity
	
	j update_player_check_x_input
	
update_player_not_on_ground:
	
update_player_check_x_input:
	lb $t6, keyboard_a_down
	bnez $t6, update_player_go_left
	lb $t6, keyboard_q_down
	bnez $t6, update_player_go_left_slow
	lb $t6, keyboard_d_down
	bnez $t6, update_player_go_right
	lb $t6, keyboard_e_down
	bnez $t6, update_player_go_right_slow
	
	j update_player_go_nowhere_x
	
update_player_go_left:
	li $t2, PLAYER_X_SPEED
	sub $t2, $zero, $t2
	sw $t2, player_x_velocity
	j update_player_check_y_input
	
update_player_go_left_slow:
	li $t2, PLAYER_X_SPEED
	srl $t2, $t2, 1
	sub $t2, $zero, $t2
	sw $t2, player_x_velocity
	j update_player_check_y_input
	
update_player_go_right:
	li $t2, PLAYER_X_SPEED
	sw $t2, player_x_velocity
	j update_player_check_y_input
	
update_player_go_right_slow:
	li $t2, PLAYER_X_SPEED
	srl $t2, $t2, 1
	sw $t2, player_x_velocity
	j update_player_check_y_input

update_player_go_nowhere_x:
	
update_player_check_y_input:
	lb $t6, keyboard_w_down
	bnez $t6, update_player_jump
	lb $t6, keyboard_q_down
	bnez $t6, update_player_jump
	lb $t6, keyboard_e_down
	bnez $t6, update_player_jump
	
	j update_player_after_input_check
	
update_player_jump:
	# Must be on ground
	beqz $t5, update_player_after_input_check
	
	li $t3, PLAYER_JUMP_Y_SPEED
	sub $t3, $zero, $t3
	sw $t3, player.physics.y_velocity($t7)
	j update_player_after_input_check
	
update_player_after_input_check:
	# Add x velocity to x pos
	add $t0, $t0, $t2
	
update_player_fix_x_1:
	bge $t0, LEFT_WALL_X, update_player_fix_x_2
	li $t0, LEFT_WALL_X	# Left edge

update_player_fix_x_2:
	ble $t0, RIGHT_WALL_X, update_player_store_x
	li $t0, RIGHT_WALL_X	# Right edge
	
update_player_store_x:
	sw $t0, player.obj.x($t7)
	
	lw $t1, player.obj.sprite($t7)
	lw $t1, sprite.width($t1)
	add $t1, $t1, $t0
	sw $t0, player.obj.bounds.x1($t7)
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	move $a0, $t7
	addi $a1, $t7, player.physics
	j apply_gravity	# Returns to current $ra
