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
	
	la $a0, level_0
	jal draw_level
	
	li $a0, 15		# x
	li $a1, 30		# y
	jal new_realplayer
	addi $sp, $sp, -4
	sw $v0, 0($sp)		# realplayer*
	
main_loop:
	jal poll_keyboard
	
	lw $a0, 0($sp)
	jal update_object
	
	li $v0, SLEEP
	li $a0, 20
	syscall
	
	j main_loop
	
	li $v0, EXIT
	syscall 
