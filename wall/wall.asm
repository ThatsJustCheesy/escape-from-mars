## typedef struct wall {
## 	object obj;
## } wall;

.eqv SIZEOF_wall 24 # SIZEOF_object

.eqv wall.obj.x 0
.eqv wall.obj.y 4
.eqv wall.obj.sprite 8
.eqv wall.obj.update 12
.eqv wall.bb 16
.eqv wall.bb.x0 16
.eqv wall.bb.y0 20
.eqv wall.bb.x1 24
.eqv wall.bb.y1 28

.text

.data
wall_sprite:	.word	5, 6, 0x00000001, 0xff2ef053, 0xff2ff053, 0xff2ef053, 0x00000000, 0xff2ff053, 0xff2ef052, 0xfffffeff, 0xff2ff053, 0xff2ef052, 0x00000100, 0xff2ef053, 0xff2ef052, 0xff2ef053, 0x00010000, 0x00000000, 0x00000100, 0xff2ef053, 0x00000000, 0x00000100, 0x00010000, 0xff2ef052, 0xff2ef153, 0xff2ef053, 0x00000000, 0xff2ef153, 0xff2ff053, 0x00000000, 0xff2ef053, 0xff2ff053

.text

## wall* new_wall(int x, int y)
## Create a new wall.
new_wall:
	move $t0, $a0
	move $t1, $a1
	
	li $a0, SIZEOF_realplayer
	jal malloc
	
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
	sh $t5, physics_state.on_ground($t1)
	sh $zero, physics_state.inputs($t1)
	
	move $v0, $t0		# return the object
	
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra
