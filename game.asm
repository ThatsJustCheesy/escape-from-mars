.include "graphics/graphics.asm"

.data
sprite:	.word	5, 6, 0x00000001, 0xff2ef053, 0xff2ff053, 0xff2ef053, 0x00000000, 0xff2ff053, 0xff2ef052, 0xfffffeff, 0xff2ff053, 0xff2ef052, 0x00000100, 0xff2ef053, 0xff2ef052, 0xff2ef053, 0x00010000, 0x00000000, 0x00000100, 0xff2ef053, 0x00000000, 0x00000100, 0x00010000, 0xff2ef052, 0xff2ef153, 0xff2ef053, 0x00000000, 0xff2ef153, 0xff2ff053, 0x00000000, 0xff2ef053, 0xff2ff053
 
.text

.globl main
main:
	jal clear
	
	li $a0, 40
	li $a1, 40
	la $a2, sprite
	li $a3, 8
	jal draw_sprite
	
	# li $t0, FB_BASE # $t0 stores the base address for display
	# li $t1, 0xff0000   # $t1 stores the red colour code
	# li $t2, 0x00ff00   # $t2 stores the green colour code
	# li $t3, 0x00ffff   # $t3 stores the blue colour code
	#
	# sw $t1, 0($t0)  # paint the first (top-left) unit red.
	# sw $t2, 4($t0)  # paint the second unit on the first row green. Why $t0+4?
	# sw $t3, 512($t0)   # paint the first unit on the second row blue. Why +256?
	
	li $v0, 10 # terminate the program gracefully 
	syscall 
