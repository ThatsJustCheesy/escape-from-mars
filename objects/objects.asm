## typedef struct object {
## 	int x, y;
## 	sprite* sprite;
## 	void (*update)(object* self);
## } object;

## void update_object(object*)
## Run updates for an object.
update_object:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	
	move $t0, $a0
	
	# Erase sprite
	lw $a0, 0($t0)
	lw $a1, 4($t0)
	lw $a2, 8($t0)
	li $a3, 1		# 1 = erase
	jal draw_sprite
	
	# Call update function if not null
	lw $t0, 4($sp)
	lw $t1, 12($t0)	# Load update function
	beqz $t1, update_object_no_update_fn
	move $a0, $t0		# Set self parameter
	jalr $t1		# Call update function
	
update_object_no_update_fn:
	
	lw $t0, 4($sp)
	
	# Draw sprite
	lw $a0, 0($t0)
	lw $a1, 4($t0)
	lw $a2, 8($t0)
	li $a3, 0		# 0 = draw
	jal draw_sprite
	
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra
