.include "graphics/graphics.asm"
.include "objects/objects.asm"
.include "util/util.asm"

.data
sprite:	.word	5, 6, 0x00000001, 0xff2ef053, 0xff2ff053, 0xff2ef053, 0x00000000, 0xff2ff053, 0xff2ef052, 0xfffffeff, 0xff2ff053, 0xff2ef052, 0x00000100, 0xff2ef053, 0xff2ef052, 0xff2ef053, 0x00010000, 0x00000000, 0x00000100, 0xff2ef053, 0x00000000, 0x00000100, 0x00010000, 0xff2ef052, 0xff2ef153, 0xff2ef053, 0x00000000, 0xff2ef153, 0xff2ff053, 0x00000000, 0xff2ef053, 0xff2ff053

## object player;
player:	.space	16
player_direction:	.word 1

debug_tmp:	.word	0

.text

.globl main
main:
	jal clear
	
	la $t0, player
	sw $zero, 0($t0)	# x
	sw $zero, 4($t0)	# y
	la $t1, sprite
	sw $t1, 8($t0)		# sprite
	la $t1, update_player
	sw $t1, 12($t0)		# update
	
	addi $sp, $sp, -12
	li $t0, 10
	sw $t0, 0($sp)
	li $t0, 50
	sw $t0, 4($sp)
	li $t0, 3
	sw $t0, 8($sp)
	
main_loop:
	la $a0, player
	jal update_object
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	la $a2, sprite
	li $a3, 0
	jal draw_sprite
	
	li $v0, SLEEP
	li $a0, 12
	syscall

	# Erase sprite
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	la $a2, sprite
	li $a3, 1
	jal draw_sprite
	
	j main_loop
	
	li $v0, EXIT
	syscall 


## void update_player(object* self)
## Update function for the player object.
update_player:
	lw $t0, 0($a0)		# x
	lw $t1, 4($a0)		# y
	lw $t2, player_direction
	
	li $t3, 120
	bge $t0, $t3, update_player_go_left
	li $t3, 5
	ble $t0, $t3, update_player_go_right
	j update_player_no_reverse
	
update_player_go_left:
	li $t2, -2
	sw $t2, player_direction
	j update_player_no_reverse
	
update_player_go_right:
	li $t2, 2
	sw $t2, player_direction
	j update_player_no_reverse

update_player_no_reverse:
	
	add $t0, $t0, $t2
	sw $t0, 0($a0)
	
	# sw $a0, debug_tmp
	# li $v0, PRINT_INTEGER
	# move $a0, $t0
	# syscall
	# lw $a0, debug_tmp
	
	addi $t1, $t1, 0
	sw $t1, 4($a0)
	
	jr $ra
