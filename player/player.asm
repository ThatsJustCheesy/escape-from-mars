## typedef struct player {
## 	object obj;
## 	physics_state physics;
## } player;

.eqv SIZEOF_player 40 # SIZEOF_object + SIZEOF_physics_state

.eqv player.obj.bounds 0
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
.eqv player.physics.x_velocity 32
.eqv player.physics.on_ground 36
.eqv player.physics.inputs 38

.eqv PLAYER_X_SPEED 4
.eqv PLAYER_JUMP_Y_SPEED 6
.eqv PLAYER_Y_ACCELERATION_DUE_TO_GRAVITY 1

.include "inputscript.asm"
.include "realplayer.asm"
.include "scriptedplayer.asm"
.include "playerstate.asm"
.include "playercollision.asm"

.text

## void update_player(object* self)
## Update function for player objects.
update_player:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $t7, $a0
	lw $t0, player.obj.x($t7)
	lw $t1, player.obj.y($t7)
	lw $t2, player.physics.x_velocity($t7)
	lw $t3, player.physics.y_velocity($t7)
	lw $t4, player.physics.y_acceleration($t7)
	
	lh $t5, player.physics.on_ground($t7)
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
	sw $t2, player.physics.x_velocity($t7)
	
	j update_player_check_x_input
	
update_player_not_on_ground:
	
update_player_check_x_input:
	lh $t9, player.physics.inputs($t7)
	andi $t6, $t9, 0x1	# a
	bnez $t6, update_player_go_left
	andi $t6, $t9, 0x2	# q
	bnez $t6, update_player_go_left_slow
	andi $t6, $t9, 0x4	# d
	bnez $t6, update_player_go_right
	andi $t6, $t9, 0x8	# e
	bnez $t6, update_player_go_right_slow
	
	j update_player_go_nowhere_x
	
update_player_go_left:
	li $t2, PLAYER_X_SPEED
	sub $t2, $zero, $t2
	sw $t2, player.physics.x_velocity($t7)
	j update_player_check_y_input
	
update_player_go_left_slow:
	li $t2, PLAYER_X_SPEED
	srl $t2, $t2, 1
	sub $t2, $zero, $t2
	sw $t2, player.physics.x_velocity($t7)
	j update_player_check_y_input
	
update_player_go_right:
	li $t2, PLAYER_X_SPEED
	sw $t2, player.physics.x_velocity($t7)
	j update_player_check_y_input
	
update_player_go_right_slow:
	li $t2, PLAYER_X_SPEED
	srl $t2, $t2, 1
	sw $t2, player.physics.x_velocity($t7)
	j update_player_check_y_input

update_player_go_nowhere_x:
	
update_player_check_y_input:
	lh $t9, player.physics.inputs($t7)
	andi $t6, $t9, 0x10	# w
	bnez $t6, update_player_jump
	andi $t6, $t9, 0x2	# q
	bnez $t6, update_player_jump
	andi $t6, $t9, 0x8	# e
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
	
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t7, 4($sp)
	
	move $a0, $t7
	addi $a1, $t7, player.physics
	jal apply_gravity
	
	lw $t7, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 8
	
update_player_fix_x_1:
	sw $t0, player.obj.x($t7)
	
	lw $t1, player.obj.sprite($t7)
	lw $t1, sprite.width($t1)
	add $t1, $t1, $t0
	sw $t1, player.obj.bounds.x1($t7)
	
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t7, 4($sp)
	
	lw $a0, current_level_layout
	addi $a1, $t7, player.obj.bounds
	li $a2, 0
	jal check_left_collision
	
	lw $t7, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 8
	
	# v0 = whether tile to left has collision
	beqz $v0, update_player_fix_x_2
	
	# Move right by one unit...
	addi $t0, $t0, 1

	sw $t0, player.obj.x($t7)
	
	lw $t1, player.obj.sprite($t7)
	lw $t1, sprite.width($t1)
	add $t1, $t1, $t0
	sw $t1, player.obj.bounds.x1($t7)
	
	li $t1, 2
	sw $t1, player.physics.x_velocity($t7)
	
	# ...repeatedly
	j update_player_fix_x_1

update_player_fix_x_2:
	sw $t0, player.obj.x($t7)
	
	lw $t1, player.obj.sprite($t7)
	lw $t1, sprite.width($t1)
	add $t1, $t1, $t0
	sw $t1, player.obj.bounds.x1($t7)
	
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t7, 4($sp)
	
	lw $a0, current_level_layout
	addi $a1, $t7, player.obj.bounds
	li $a2, 0
	jal check_right_collision
	
	lw $t7, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 8
	
	# v0 = whether tile to right has collision
	beqz $v0, update_player_store_x
	
	# Move left by one unit...
	addi $t0, $t0, -1

	sw $t0, player.obj.x($t7)
	
	lw $t1, player.obj.sprite($t7)
	lw $t1, sprite.width($t1)
	add $t1, $t1, $t0
	sw $t1, player.obj.bounds.x1($t7)
	
	li $t1, -2
	sw $t1, player.physics.x_velocity($t7)
	
	# ...repeatedly
	j update_player_fix_x_1
	
update_player_store_x:
	sw $t0, player.obj.x($t7)
	
	lw $t1, player.obj.sprite($t7)
	lw $t1, sprite.width($t1)
	add $t1, $t1, $t0
	sw $t1, player.obj.bounds.x1($t7)
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
