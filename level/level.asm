.include "leveltiles.asm"
.include "levellayouts.asm"

.data
comma:	.asciiz	","

.text

## int xy2level_offset(int x, int y)
## Convert (x,y)-based coordinates to a level_layout offset.
xy2level_offset:
	sra $a0, $a0, 3
	sra $a1, $a1, 3
	
	bltz $a1, xy2level_offset_cap_at_top
	bge $a1, LAYOUT_HEIGHT, xy2level_offset_cap_at_bottom
	j xy2level_offset_after_cap
	
xy2level_offset_cap_at_top:
	move $a1, $zero
	j xy2level_offset_after_cap
	
xy2level_offset_cap_at_bottom:
	li $a1, LAYOUT_HEIGHT
	addi $a1, $a1, -1
	j xy2level_offset_after_cap
	
xy2level_offset_after_cap:
	## DEBUGGING
	move $s7, $a0
	li $v0, PRINT_INTEGER
	move $s6, $a0
	move $a0, $s7
	syscall
	li $v0, PRINT_STRING
	la $a0, comma
	syscall
	move $a0, $s6
	move $v0, $s7
	## END
	## DEBUGGING
	move $s7, $a1
	li $v0, PRINT_INTEGER
	move $s6, $a0
	move $a0, $s7
	syscall
	li $v0, PRINT_STRING
	la $a0, newline
	syscall
	move $a0, $s6
	move $v0, $s7
	## END
	
	mul $v0, $a1, LAYOUT_WIDTH
	add $v0, $v0, $a0
	sll $v0, $v0, 2
	jr $ra
	
	# addi $sp, $sp, -4
	# sw $ra, 0($sp)
	#
	# div $a0, $a0, TILE_WIDTH
	# div $a1, $a1, TILE_HEIGHT
	# jal xy2offset
	# # sra $v0, $v0, 4
	# # andi $v0, $v0, 0xfffffffc
	#
	# lw $ra, 0($sp)
	# addi $sp, $sp, 4
	#
	# jr $ra


## void draw_level(level_layout* layout)
## Draw the level described by `layout`.
draw_level:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# t0 = layout
	move $t0, $a0
	
	# t1 = counter
	move $t1, $zero
	
draw_level_loop:
	# t3 = layout cursor
	sll $t3, $t1, 2
	add $t3, $t3, $t0
	
	li $t8, LAYOUT_WIDTH
	div $t1, $t8
	mfhi $a0
	sll $a0, $a0, 3	# log(TILE_WIDTH)
	mflo $a1
	sll $a1, $a1, 3	# log(TILE_HEIGHT)
	
	# If y = max y, we are done
	beq $a1, DISPLAY_HEIGHT, draw_level_end
	
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	
	lw $a2, ($t3)
	lw $a2, level_layout_tile.graphics($a2)
	move $a3, $zero
	jal draw_sprite
	
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 8
	
	addi $t1, $t1, 1
	j draw_level_loop
	
draw_level_end:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
