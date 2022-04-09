.data

.align 2
malloc_zone:	.space	0x16000
malloc_index:	.word	0

.text

## void* malloc(int size)
## Allocate `size` bytes of scratch space.
malloc:
	addi $sp, $sp, -4	##########################
	sw $s0, 0($sp)
	
	lw $s0, malloc_index
	
	la $v0, malloc_zone
	add $v0, $v0, $s0
	
	add $s0, $s0, $a0
	sw $s0, malloc_index
	
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
