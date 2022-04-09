.data
realplayer_sprite:	.word	5, 6, 0x00000000, 0xff163fd8, 0xff163ed8, 0xff163ed8, 0x00000100, 0xff163ed9, 0xff52f02e, 0xffffffff, 0xff52f02f, 0xff163ed8, 0x00000100, 0xff52f02f, 0xff53f02f, 0xff53f12e, 0x00000000, 0x00000000, 0x00000100, 0xff52f02e, 0x00010000, 0x00000100, 0x00000000, 0xff52f02e, 0xff53f12e, 0xff53f02e, 0x00000000, 0xff53f12e, 0xff53f02f, 0x00000000, 0xff53f02e, 0xff52f02e

.text

## player* new_realplayer(int x, int y)
## Create a new realplayer.
new_realplayer:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $t0, $a0
	move $t1, $a1
	
	li $a0, SIZEOF_player
	jal malloc
	
	addi $sp, $sp, -4
	sw $v0, 0($sp)		# save new object for later
	
	move $a0, $v0		# obj
	move $a1, $t0		# x
	move $a2, $t1		# y
	la $a3, realplayer_sprite	# sprite

	la $t0, update_realplayer
	addi $sp, $sp, -4
	sw $t0, 0($sp)		# update
	
	jal init_object
	
	lw $t0, 0($sp)		# saved object
	
	addi $t1, $t0, player.physics
	sw $zero, physics_state.y_velocity($t1)
	li $t5, PLAYER_Y_ACCELERATION_DUE_TO_GRAVITY
	sw $t5, physics_state.y_acceleration($t1)
	sw $zero, physics_state.x_velocity($t1)
	li $t5, 1
	sh $t5, physics_state.on_ground($t1)
	sh $zero, physics_state.inputs($t1)
	
	move $v0, $t0		# return the object
	
	addi $sp, $sp, 4
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra


## void update_realplayer(object* self)
## Update function for realplayer objects.
update_realplayer:
	lb $t9, keyboard_a_down
	move $t8, $t9
	lb $t9, keyboard_q_down
	sll $t9, $t9, 1
	or $t8, $t8, $t9
	lb $t9, keyboard_d_down
	sll $t9, $t9, 2
	or $t8, $t8, $t9
	lb $t9, keyboard_e_down
	sll $t9, $t9, 3
	or $t8, $t8, $t9
	lb $t9, keyboard_w_down
	sll $t9, $t9, 4
	or $t8, $t8, $t9
	sh $t8, player.physics.inputs($a0)
	
	j update_player
