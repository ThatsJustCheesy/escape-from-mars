.include "util/util.asm"
.include "graphics/graphics.asm"
.include "objects/objects.asm"
.include "level/level.asm"
.include "physics/physics.asm"
.include "player/player.asm"
.include "input/input.asm"

.text

.globl main
main:
	jal clear
	
	la $a0, level_1
	jal draw_level
	
	li $a0, 15		# x
	li $a1, 110		# y
	jal new_realplayer
	addi $sp, $sp, -4
	sw $v0, 0($sp)		# realplayer*
	
main_loop:
	jal poll_keyboard

	lb $t0, keyboard_p_down
	beqz $t0, main_no_restart
	
	addi $sp, $sp, 4
	j main

main_no_restart:
	lw $a0, 0($sp)
	jal update_object
	
	li $v0, SLEEP
	li $a0, 20
	syscall
	
	j main_loop
	
	li $v0, EXIT
	syscall 
