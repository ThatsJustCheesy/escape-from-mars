.include "util/util.asm"
.include "graphics/graphics.asm"
.include "objects/objects.asm"
.include "level/level.asm"
.include "physics/physics.asm"
.include "player/player.asm"
.include "interactives/interactives.asm"
.include "input/input.asm"

.text

.globl main
main:
	jal clear
	
	la $a0, level_1
	la $a1, level_1_objects
	jal start_level
	
	jal reset_players
	
main_loop:
	jal poll_keyboard

	lb $t0, keyboard_p_down
	beqz $t0, main_no_restart
	
	addi $sp, $sp, 4
	j main

main_no_restart:
	move $a0, $zero
	jal update_current_level
	
	jal update_players
	
	li $v0, SLEEP
	li $a0, 20
	syscall
	
	j main_loop
	
	li $v0, EXIT
	syscall 
