.data

current_level_layout:	.word	0
current_level_objects_template:	.word	level_1_objects
current_level_objects:	.word	0:97	# 1 for count, plus 16 * (SIZEOF_object / 4)

.text


## void start_level(level_layout* layout, level_objects* objects)
## (Re)start the level described by `layout` and `objects`.
start_level:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	
	jal draw_level

	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	
	sw $a0, current_level_layout
	sw $a1, current_level_objects_template
	
	lw $t0, level_objects.count($a1)
	la $t1, current_level_objects
	sw $t0, level_objects.count($t1)
	
	lw $t1, current_level_objects_template
	addi $t1, $t1, level_objects.objects
	la $t2, current_level_objects
	addi $t2, $t2, 4
	
start_level_copy_objects_loop:
	beqz $t0, start_level_copy_objects_end
	
	# Actual object data
	lw $t4, ($t1)
	
	lw $t3, object.bounds.x0($t4)
	sw $t3, object.bounds.x0($t2)
	lw $t3, object.bounds.y0($t4)
	sw $t3, object.bounds.y0($t2)
	lw $t3, object.bounds.x1($t4)
	sw $t3, object.bounds.x1($t2)
	lw $t3, object.bounds.y1($t4)
	sw $t3, object.bounds.y1($t2)
	lw $t3, object.sprite($t4)
	sw $t3, object.sprite($t2)
	lw $t3, object.update($t4)
	sw $t3, object.update($t2)
	
	addi $t1, $t1, 4
	addi $t2, $t2, SIZEOF_object
	
	addi $t0, $t0, -1
	j start_level_copy_objects_loop
	
start_level_copy_objects_end:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	j update_current_level
	

## void update_current_level(void)
## Trigger updates for all loaded objects, and redraw the current level layout.
update_current_level:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	
	# s0 = counter
	la $t0, current_level_objects
	lw $s0, 0($t0)
	
	# s1 = cursor into object list
	la $s1, current_level_objects
	addi $s1, $s1, 4
	
update_current_level_update_objects_loop:
	beqz $s0, update_current_level_update_objects_end
	
	move $a0, $s1
	jal update_object
	
	addi $s1, $s1, SIZEOF_object
	
	addi $s0, $s0, -1
	j update_current_level_update_objects_loop
	
update_current_level_update_objects_end:
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra


## void load_object(object*)
## Copy the given object to the list of currently loaded objects.
load_object:
	# Increment count
	lw $t0, current_level_objects
	addi $t0, $t0, 1
	sw $t0, current_level_objects
	
	# Compute next empty slot address
	la $t1, current_level_objects
	addi $t1, $t1, 4	# skip count
	mul $t0, $t0, SIZEOF_object
	add $t1, $t1, $t0
	
	# Copy object to empty slot
	lw $t3, object.bounds.x0($a0)
	sw $t3, object.bounds.x0($t1)
	lw $t3, object.bounds.y0($a0)
	sw $t3, object.bounds.y0($t1)
	lw $t3, object.bounds.x1($a0)
	sw $t3, object.bounds.x1($t1)
	lw $t3, object.bounds.y1($a0)
	sw $t3, object.bounds.y1($t1)
	lw $t3, object.sprite($a0)
	sw $t3, object.sprite($t1)
	lw $t3, object.update($a0)
	sw $t3, object.update($t1)
	
	jr $ra


.data

empty_sprite:	.word	0, 0

.text

## void nop_update(object* self)
## An update function that does nothing.
nop_update:
	jr $ra


## void unload_object(object*)
## Remove the given object from the list of currently loaded objects.
## (Actually just "disables" the object for now, for simplicity.)
unload_object:
	la $t3, empty_sprite
	sw $t3, object.sprite($a0)
	la $t3, nop_update
	sw $t3, object.update($a0)

	jr $ra
