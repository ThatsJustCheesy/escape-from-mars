.include "util/util.asm"
.include "graphics/graphics.asm"
.include "memory/memory.asm"
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
	
	la $a0, level_3
	la $a1, level_3_objects
	jal start_level
	
	jal reset_players
	
main_loop:
	jal poll_keyboard

	lb $t0, keyboard_p_down
	beqz $t0, main_no_restart
	
	addi $sp, $sp, 4
	j main

main_no_restart:
	lb $t0, keyboard_r_down
	beqz $t0, main_no_restart_level
	
	jal reset_players
	jal clear
	jal restart_current_level
	
main_no_restart_level:
	jal record_input
	
	move $a0, $zero
	jal update_current_level
	
	jal update_players
	
	lw $t0, current_level_layout
	la $t1, win_screen
	beq $t0, $t1, main_exit
	
	li $v0, SLEEP
	li $a0, 20
	syscall
	
	j main_loop
	
main_exit:
	li $v0, EXIT
	syscall 
