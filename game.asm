#####################################################################
#
# CSCB58 Winter 2022 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Ian Gregory, 1007249087, grego124, ian.gregory@mail.utoronto.ca
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4 (update this as needed)
# - Unit height in pixels: 4 (update this as needed)
# - Display width in pixels: 512 (update this as needed)
# - Display height in pixels: 512 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestones 1, 2, 3
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. Win condition
# 2. Disappearing platforms
# 3. Different levels
# 4. Pick-up effects
# 5. Player clones
#
# Link to video demonstration for final submission:
# - https://youtu.be/Mggqq0vZV8Y
#
# Are you OK with us sharing the video with people outside course staff?
# - yes, and please share this project github link as well!
#   https://github.com/ThatsJustCheesy/escape-from-mars
#
# Any additional information that the TA needs to know:
# - I split my code across multiple files using the ".include" directive.
#   To play the game, you can open just game.asm in Mars.
#   (If needed, please use another text editor to view the rest of the code.)
#
# #####################################################################

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
