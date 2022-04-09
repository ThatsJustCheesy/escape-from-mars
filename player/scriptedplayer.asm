## typedef struct scriptedplayer {
## 	player player;
## 	input_script* script;
## 	int frame_index;
## } scriptedplayer;

.eqv SIZEOF_scriptedplayer 60

.eqv scriptedplayer.player 0
.eqv scriptedplayer.script 40
.eqv scriptedplayer.frame_index 44

.data
scriptedplayer_sprite:	.word	5, 6, 0x00000000, 0xff163fd8, 0xff163ed8, 0xff163ed8, 0x00000100, 0xff163ed9, 0xff52f02e, 0xffffffff, 0xff52f02f, 0xff163ed8, 0x00000100, 0xff52f02f, 0xff53f02f, 0xff53f12e, 0x00000000, 0x00000000, 0x00000100, 0xff52f02e, 0x00010000, 0x00000100, 0x00000000, 0xff52f02e, 0xff53f12e, 0xff53f02e, 0x00000000, 0xff53f12e, 0xff53f02f, 0x00000000, 0xff53f02e, 0xff52f02e

.text

## scriptedplayer* new_scriptedplayer(int x, int y, input_script* script)
## Create a new scriptedplayer.
new_scriptedplayer:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $t0, $a0
	move $t1, $a1
	move $t2, $a2
	
	li $a0, SIZEOF_scriptedplayer
	jal malloc
	
	addi $sp, $sp, -8
	sw $v0, 0($sp)		# save new object for later
	sw $t2, 4($sp)		# save script pointer for later
	
	move $a0, $v0		# obj
	move $a1, $t0		# x
	move $a2, $t1		# y
	la $a3, scriptedplayer_sprite	# sprite

	la $t0, update_scriptedplayer
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
	
	lw $t2, 4($sp)		# saved script pointer
	sw $t2, scriptedplayer.script($t0)
	
	sw $zero, scriptedplayer.frame_index($t0)
	
	move $v0, $t0		# return the object
	
	addi $sp, $sp, 8
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra


## void update_scriptedplayer(object* self)
## Update function for scriptedplayer objects.
update_scriptedplayer:
	lw $t0, scriptedplayer.script($a0)
	
	lw $t1, input_script_step.frame_index($t0)
	lw $t2, scriptedplayer.frame_index($a0)
	blt $t2, $t1, update_scriptedplayer_no_inputs
	
	lh $t8, input_script_step.input($t0)
	# beq $t8, 0xffff, update_scriptedplayer_die
	sh $t8, player.physics.inputs($a0)
	
	## DEBUGGING
	move $s7, $a0
	li $v0, PRINT_INTEGER
	move $a0, $t1
	syscall
	li $v0, PRINT_STRING
	la $a0, comma
	syscall
	li $v0, PRINT_INTEGER
	move $a0, $t2
	syscall
	li $v0, PRINT_STRING
	la $a0, comma
	syscall
	li $v0, PRINT_INTEGER
	move $a0, $t8
	syscall
	li $v0, PRINT_STRING
	la $a0, newline
	syscall
	move $a0, $s7
	## END DEBUGGING
	
	addi $t0, $t0, SIZEOF_input_script_step
	sw $t0, scriptedplayer.script($a0)
	
	j update_scriptedplayer_end

# update_scriptedplayer_die:
# 	j unload_object
	
update_scriptedplayer_no_inputs:
	sh $zero, player.physics.inputs($a0)
	
update_scriptedplayer_end:
	# Increment current frame index
	addi $t2, $t2, 1
	sw $t2, scriptedplayer.frame_index($a0)
	
	j update_player
