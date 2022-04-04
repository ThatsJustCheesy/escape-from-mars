## typedef struct object {
## 	bounding_box bounds;
## 	sprite* sprite;
## 	void (*update)(object* self);
## } object;

.eqv SIZEOF_object 24	# SIZEOF_bounding_box + 8

.eqv object.bounds 0
.eqv object.x 0
.eqv object.bounds.x0 0
.eqv object.y 4
.eqv object.bounds.y0 4
.eqv object.bounds.x1 8
.eqv object.bounds.y1 12
.eqv object.sprite 16
.eqv object.update 20

.text

## void init_object(object* obj, int x, int y, sprite* sprite, void (*update)(object* self))
## Initialize object `obj`.
init_object:
	sw $a1, object.bounds.x0($a0)
	sw $a2, object.bounds.y0($a0)
	sw $a3, object.sprite($a0)
	
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	sw $t0, object.update($a0)
	
	lw $t0, sprite.width($a3)
	add $t0, $t0, $a1
	sw $t0, object.bounds.x1($a0)
	
	lw $t0, sprite.height($a3)
	add $t0, $t0, $a2
	sw $t0, object.bounds.y1($a0)
	
	jr $ra


## void update_object(object*)
## Run updates for an object.
update_object:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	
	move $t0, $a0
	
	# Erase sprite
	lw $a0, object.x($t0)
	lw $a1, object.y($t0)
	lw $a2, object.sprite($t0)
	li $a3, 1		# 1 = erase
	jal draw_sprite
	
	# Redraw surrounding level tiles
	
	lw $t0, 4($sp)
	
	lw $a0, current_level_layout
	lw $a1, object.bounds.x0($t0)
	lw $a2, object.bounds.y0($t0)
	jal draw_level_tile
	
	lw $t0, 4($sp)
	
	lw $a0, current_level_layout
	lw $a1, object.bounds.x1($t0)
	lw $a2, object.bounds.y0($t0)
	jal draw_level_tile
	
	lw $t0, 4($sp)
	
	lw $a0, current_level_layout
	lw $a1, object.bounds.x0($t0)
	lw $a2, object.bounds.y1($t0)
	jal draw_level_tile
	
	lw $t0, 4($sp)
	
	lw $a0, current_level_layout
	lw $a1, object.bounds.x1($t0)
	lw $a2, object.bounds.y1($t0)
	jal draw_level_tile
	
	lw $t0, 4($sp)
	
	# Call update function if not null
	lw $t0, 4($sp)
	lw $t1, object.update($t0)
	beqz $t1, update_object_no_update_fn
	move $a0, $t0		# Set self parameter
	jalr $t1		# Call update function
	
update_object_no_update_fn:
	
	lw $t0, 4($sp)
	
	# Draw sprite
	lw $a0, object.x($t0)
	lw $a1, object.y($t0)
	lw $a2, object.sprite($t0)
	li $a3, 0		# 0 = draw
	jal draw_sprite
	
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra


.include "pickup.asm"
.include "activator.asm"
