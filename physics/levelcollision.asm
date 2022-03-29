.text

## bounding_box find_floor(level_layout* level, bounding_box* bounds)
## Return the bounding box of the first solid tile of `level`
## directly beneath `bounds`.
# find_floor:
# 	lw $t0, bounding_box.x0($a0)
# 	lw $t1, bounding_box.y0($a0)
# 	lw $t2, bounding_box.x1($a0)
# 	lw $t3, bounding_box.y1($a0)
#
# find_floor_loop:
# 	bgt $t3, DISPLAY_HEIGHT, find_floor_end
#
#
#
# 	addi $t3, $t3, TILE_HEIGHT
# 	j find_floor_loop
#
# find_floor_end:
# 	subi $sp, $sp, SIZEOF_bounding_box
# 	sw $t0, bounding_box.x0($sp)
# 	sw $t1, bounding_box.y0($sp)
# 	sw $t2, bounding_box.x1($sp)
# 	sw $t3, bounding_box.y1($sp)
#
# 	jr $ra


## typedef struct bounding_box_list {
## 	int count;
## 	bounding_box boxes[count];
## } bounding_box_list;

# .eqv bounding_box_list.count 0
# .eqv bounding_box_list.boxes 4
#
# .data
# bounding_box_list:	.word	0:512	# LAYOUT_WIDTH * LAYOUT_HEIGHT
#
# .text

## int get_colliding_level_tiles(level_layout* layout, bounding_box* bounds)
## Find the bounding boxes of all solid level tiles of `layout`
## that collide with `bounds`.
# get_colliding_level_tiles:
# 	addi $sp, $sp, -4
# 	sw $ra, 0($sp)
#
# 	la $t9, bounding_box_list
# 	sw $zero, bounding_box_list.count($t9)
#
# 	# t6 = layout
# 	move $t6, $a0
#
# 	# t0-t3 = x0,y0,x1,y1
# 	lw $t0, bounding_box.x0($a1)
# 	lw $t1, bounding_box.y0($a1)
# 	lw $t2, bounding_box.x1($a1)
# 	lw $t3, bounding_box.y1($a1)
#
# 	# t4 = current x
# 	# t5 = current y
# 	move $t4, $t0
# 	move $t5, $t1
#
# 	# t7 = bounding box count
# 	move $t7, $zero
#
# 	# Jump to top-left of relevant level tiles
# 	# Iterate until past bottom-right of relevant level tiles
# 	# For each, if collides with `bounds`, add to list
#
# get_colliding_level_tiles_loop:
# 	ble $t4, $t2, get_colliding_level_tiles_check_collision
# 	# Reset x, increment y
# 	move $t4, $t0
# 	addi $t5, $t5, TILE_HEIGHT
#
# 	ble $t5, $t3, get_colliding_level_tiles_check_collision
# 	j get_colliding_level_tiles_end
#
# get_colliding_level_tiles_check_collision:
# 	move $a0, $t4
# 	move $a1, $t5
# 	jal xy2level_offset
#
# 	# v0 = (current layout tile).collision
# 	add $v0, $v0, $t6	# cursor into level_layout
# 	lw $v0, ($v0)		# level_layout_tile*
# 	lw $v0, level_layout_tile.collision($v0)
#
# 	# ## DEBUGGING
# 	# move $s1, $v0
# 	# li $v0, PRINT_INTEGER
# 	# move $s0, $a0
# 	# move $a0, $s1
# 	# syscall
# 	# li $v0, PRINT_STRING
# 	# la $a0, newline
# 	# syscall
# 	# move $a0, $s0
# 	# move $v0, $s1
# 	# ## END
#
# 	beqz $v0, get_colliding_level_tiles_continue_loop
#
# get_colliding_level_tiles_add_to_bounding_box_list:
# 	# t8 = bounding box list cursor
# 	sll $t8, $t7, 2	# depends on SIZEOF_bounding_box
# 	la $t9, bounding_box_list
# 	addi $t9, $t9, bounding_box_list.boxes	# skip count
# 	add $t8, $t8, $t9
#
# 	# Store x0, x1 in next bounding box of list
# 	sw $t4, bounding_box.x0($t8)
# 	addi $t4, $t4, TILE_WIDTH
# 	sw $t4, bounding_box.x1($t8)
# 	subi $t4, $t4, TILE_WIDTH
#
# 	# Store y0, y1 in next bounding box of list
# 	sw $t5, bounding_box.y0($t8)
# 	addi $t5, $t5, TILE_HEIGHT
# 	sw $t5, bounding_box.y1($t8)
# 	subi $t5, $t5, TILE_HEIGHT
#
# 	## DEBUGGING
# 	move $s1, $t4
# 	li $v0, PRINT_INTEGER
# 	move $s0, $a0
# 	move $a0, $s1
# 	syscall
# 	li $v0, PRINT_STRING
# 	la $a0, comma
# 	syscall
# 	move $a0, $s0
# 	move $t4, $s1
# 	## END
# 	## DEBUGGING
# 	move $s1, $t5
# 	li $v0, PRINT_INTEGER
# 	move $s0, $a0
# 	move $a0, $s1
# 	syscall
# 	li $v0, PRINT_STRING
# 	la $a0, newline
# 	syscall
# 	move $a0, $s0
# 	move $t5, $s1
# 	## END
#
# 	# Increment bounding box count
# 	addi $t7, $t7, 1
#
# 	# TEMP: Stop after 1
# 	j get_colliding_level_tiles_end
#
# get_colliding_level_tiles_continue_loop:
# 	# Increment x
# 	addi $t4, $t4, TILE_WIDTH
#
# 	j get_colliding_level_tiles_loop
#
# get_colliding_level_tiles_end:
# 	# Store bounding box count
# 	la $t9, bounding_box_list
# 	sw $t7, bounding_box_list.count($t9)
#
# 	lw $ra, 0($sp)
# 	addi $sp, $sp, 4
#
# 	move $v0, $t7
#
# 	jr $ra

## bool check_bottom_collision(level_layout* layout, bounding_box* bounds, bool check_below)
## Return whether the bottom of `bounds` collides with a solid
## tile in `layout`. If `check_below` is set, then a solid tile
## immediately below `bounds` also counts.
check_bottom_collision:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	# t0 = x0
	lw $t0, bounding_box.x0($a1)

	# t1 = y1 + check_below
	lw $t1, bounding_box.y1($a1)
	add $t1, $t1, $a2

	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)

	move $a0, $t0
	move $a1, $t1
	jal xy2level_offset

	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 12

	# v0 = (current layout tile).collision
	add $t1, $a0, $v0	# cursor into level_layout
	lw $t1, ($t1)		# level_layout_tile*
	lw $v0, level_layout_tile.collision($t1)
	
	bnez $v0, check_bottom_collision_end
	
	# t0 = x1
	lw $t0, bounding_box.x1($a1)

	# t1 = y1 + check_below
	lw $t1, bounding_box.y1($a1)
	add $t1, $t1, $a2

	addi $sp, $sp, -4
	sw $a0, 0($sp)

	move $a0, $t0
	move $a1, $t1
	jal xy2level_offset

	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	# v0 = (current layout tile).collision
	add $t1, $a0, $v0	# cursor into level_layout
	lw $t1, ($t1)		# level_layout_tile*
	lw $v0, level_layout_tile.collision($t1)
	
check_bottom_collision_end:
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra


## bool check_top_collision(level_layout* layout, bounding_box* bounds, bool check_above)
## Return whether the top of `bounds` collides with a solid
## tile in `layout`. If `check_above` is set, then a solid tile
## immediately above `bounds` also counts.
check_top_collision:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	# t0 = x0
	lw $t0, bounding_box.x0($a1)

	# t1 = y0 - check_above
	lw $t1, bounding_box.y0($a1)
	sub $t1, $t1, $a2

	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)

	move $a0, $t0
	move $a1, $t1
	jal xy2level_offset

	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 12

	# v0 = (current layout tile).collision
	add $t1, $a0, $v0	# cursor into level_layout
	lw $t1, ($t1)		# level_layout_tile*
	lw $v0, level_layout_tile.collision($t1)
	
	bnez $v0, check_top_collision_end
	
	# t0 = x1
	lw $t0, bounding_box.x1($a1)

	# t1 = y0 - check_above
	lw $t1, bounding_box.y0($a1)
	sub $t1, $t1, $a2

	addi $sp, $sp, -4
	sw $a0, 0($sp)

	move $a0, $t0
	move $a1, $t1
	jal xy2level_offset

	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	# v0 = (current layout tile).collision
	add $t1, $a0, $v0	# cursor into level_layout
	lw $t1, ($t1)		# level_layout_tile*
	lw $v0, level_layout_tile.collision($t1)
	
check_top_collision_end:
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra


## bool check_left_collision(level_layout* layout, bounding_box* bounds, bool check_to_left)
## Return whether the left of `bounds` collides with a solid
## tile in `layout`. If `check_to_left` is set, then a solid tile
## immediately to the left of `bounds` also counts.
check_left_collision:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	# t0 = y0
	lw $t0, bounding_box.y0($a1)

	# t1 = x0 - check_to_left
	lw $t1, bounding_box.x0($a1)
	sub $t1, $t1, $a2

	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)

	move $a0, $t1
	move $a1, $t0
	jal xy2level_offset

	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 12

	# v0 = (current layout tile).collision
	add $t1, $a0, $v0	# cursor into level_layout
	lw $t1, ($t1)		# level_layout_tile*
	lw $v0, level_layout_tile.collision($t1)
	
	bnez $v0, check_left_collision_end
	
	# t0 = y1
	lw $t0, bounding_box.y1($a1)

	# t1 = x0 - check_to_left
	lw $t1, bounding_box.x0($a1)
	sub $t1, $t1, $a2

	addi $sp, $sp, -4
	sw $a0, 0($sp)

	move $a0, $t1
	move $a1, $t0
	jal xy2level_offset

	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	# v0 = (current layout tile).collision
	add $t1, $a0, $v0	# cursor into level_layout
	lw $t1, ($t1)		# level_layout_tile*
	lw $v0, level_layout_tile.collision($t1)
	
check_left_collision_end:
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra


## bool check_right_collision(level_layout* layout, bounding_box* bounds, bool check_to_right)
## Return whether the right of `bounds` collides with a solid
## tile in `layout`. If `check_to_right` is set, then a solid tile
## immediately to the right of `bounds` also counts.
check_right_collision:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	# t0 = y0
	lw $t0, bounding_box.y0($a1)

	# t1 = x1 + check_to_right
	lw $t1, bounding_box.x1($a1)
	add $t1, $t1, $a2

	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)

	move $a0, $t1
	move $a1, $t0
	jal xy2level_offset

	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 12

	# v0 = (current layout tile).collision
	add $t1, $a0, $v0	# cursor into level_layout
	lw $t1, ($t1)		# level_layout_tile*
	lw $v0, level_layout_tile.collision($t1)
	
	bnez $v0, check_right_collision_end
	
	# t0 = y1
	lw $t0, bounding_box.y1($a1)

	# t1 = x1 + check_to_right
	lw $t1, bounding_box.x1($a1)
	add $t1, $t1, $a2

	addi $sp, $sp, -4
	sw $a0, 0($sp)

	move $a0, $t1
	move $a1, $t0
	jal xy2level_offset

	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	# v0 = (current layout tile).collision
	add $t1, $a0, $v0	# cursor into level_layout
	lw $t1, ($t1)		# level_layout_tile*
	lw $v0, level_layout_tile.collision($t1)
	
check_right_collision_end:
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra
