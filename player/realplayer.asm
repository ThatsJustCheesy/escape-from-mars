.data
realplayer_sprite:	.word	5, 6, 0x00000000, 0xff163fd8, 0xff163ed8, 0xff163ed8, 0x00000100, 0xff163ed9, 0xff52f02e, 0xffffffff, 0xff52f02f, 0xff163ed8, 0x00000100, 0xff52f02f, 0xff53f02f, 0xff53f12e, 0x00000000, 0x00000000, 0x00000100, 0xff52f02e, 0x00010000, 0x00000100, 0x00000000, 0xff52f02e, 0xff53f12e, 0xff53f02e, 0x00000000, 0xff53f12e, 0xff53f02f, 0x00000000, 0xff53f02e, 0xff52f02e

.text

## realplayer* new_realplayer(int x, int y)
## Create a new realplayer.
new_realplayer:
	move $t0, $a0
	move $t1, $a1
	
	li $v0, MALLOC
	li $a0, SIZEOF_player
	syscall
	
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $v0, 4($sp)		# save new object for later
	
	move $a0, $v0		# obj
	move $a1, $t0		# x
	move $a2, $t1		# y
	la $a3, realplayer_sprite	# sprite

	la $t0, update_player
	addi $sp, $sp, -4
	sw $t0, 0($sp)		# update
	
	jal init_object
	
	lw $t0, 4($sp)		# saved object
	
	addi $t1, $t0, player.physics
	sw $zero, physics_state.y_velocity($t1)
	li $t5, PLAYER_Y_ACCELERATION_DUE_TO_GRAVITY
	sw $t5, physics_state.y_acceleration($t1)
	sw $zero, physics_state.x_velocity($t1)
	li $t5, 1
	sw $t5, physics_state.on_ground($t1)
	
	move $v0, $t0		# return the object
	
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra
