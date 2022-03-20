# Sprite drawing

.data
newline:	.asciiz "\n"

.text

## typedef struct sprite {
## 	int width, height;
## 	char pixels[width][height];
## } sprite;

## void draw_sprite(int x, int y, sprite* pixels, bool erase)
## Draw the sprite data pointed to by `pixels`,
## with the top-left corner anchored at (`x`, `y`).
## If `erase` is set, erase the sprite instead of drawing it.
draw_sprite:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# t3 = left sprite x
	li $t3, 0
	# t4 = top sprite y
	li $t4, 0
	
	# Clip left side?
	bgez $a0, draw_sprite_no_left_clip
	# Yes
	
	# left sprite x = 0 - x
	# (x is negative)
	sub $t3, $zero, $a0
	# x = 0
	li $a0, 0

draw_sprite_no_left_clip:
	# Clip top side?
	bgez $a1, draw_sprite_no_top_clip
	# Yes
	li $a1, 0
	
	# top sprite y = 0 - y
	# (y is negative)
	sub $t4, $zero, $a1
	# y = 0
	li $a1, 0

draw_sprite_no_top_clip:
	# t7 = width of sprite
	lw $t7, 0($a2)
	# t8 = height of sprite
	lw $t8, 4($a2)
	# t9 = one-past-the-end pointer into pixel data
	mul $t9, $t7, $t8	# width of sprite * height of sprite
	sll $t9, $t9, 2
	add $t9, $a2, $t9
	
	# # Adjust width and height of sprite
	# # according to left and top clips
	# sub $t7, $t7, $t3	# -= left sprite x
	# sub $t8, $t8, $t4	# -= top sprite y
	
	# Clip right side?
	li $t0, DISPLAY_WIDTH
	add $t1, $a0, $t7	#  x + width of sprite
	blt $t1, $t0, draw_sprite_no_right_clip
	
	# Yes
	# width = DISPLAY_WIDTH - x
	sub $t7, $t0, $a0
	
draw_sprite_no_right_clip:
	# Clip bottom side?
	li $t0, DISPLAY_HEIGHT
	add $t1, $a1, $t8	# y + height of sprite
	blt $t1, $t0, draw_sprite_no_bottom_clip
	
	# Yes
	# height = DISPLAY_HEIGHT - y
	sub $t8, $t0, $a1
	
draw_sprite_no_bottom_clip:
	# Discard width and height fields
	addi $a2, $a2, 8
	addi $t9, $t9, 8
	
	# t0 = initial fb cursor
	jal xy2offset
	addi $t0, $v0, FB_BASE
	
	# t2 = pixels offset
	# t2 = 4 * (left sprite x + (width of sprite * top sprite y))
	mul $t2, $t7, $t4
	add $t2, $t2, $t3
	sll $t2, $t2, 2
	# t2 = pixels cursor
	add $t2, $a2, $t2
	
	# t6 = initial y
	move $t6, $a1
draw_sprite_loop_over_y:
	# t1 = y - initial y + top sprite y
	# If y - initial y >= height of sprite - top sprite y, we are done
	sub $t1, $a1, $t6
	add $t1, $t1, $t4
	bge $t1, $t8, draw_sprite_end_loop_over_y
	
	# t5 = initial x
	move $t5, $a0
draw_sprite_loop_over_x:
	# t1 = x - initial x + left sprite x
	# If x - initial x >= height of sprite - left sprite x, we are done
	sub $t1, $a0, $t5
	add $t1, $t1, $t3
	bge $t1, $t7, draw_sprite_end_loop_over_x
	
	# t1 = fb cursor
	jal xy2offset
	addi $t1, $v0, FB_BASE
	
	# ## DEBUGGING
	# move $s1, $v0
	# li $v0, 1
	# move $s0, $a0
	# move $a0, $s1
	# srl $a0, $a0, 2
	# syscall
	# li $v0, 4
	# la $a0, newline
	# syscall
	# move $a0, $s0
	# ## END
	
	# If pixels cursor >= t9, we are done
	bge $t2, $t9, draw_sprite_end
	
	# Load pixel and check if transparent
	lw $v0, ($t2)
	andi $v1, $v0, 0xFF000000
	beqz $v1, draw_sprite_transparent_pixel
	
	# Pixel not transparent; check if we should draw or erase
	beqz $a3, draw_sprite_copy_pixel
	
	# Erase by copying background color to framebuffer
	li $v0, BACKGROUND_COLOR
	
draw_sprite_copy_pixel:
	# Copy pixel to framebuffer
	sw $v0, ($t1)

draw_sprite_transparent_pixel:
	# ++x
	addi $a0, $a0, 1
	# Advance pixels cursor
	addi $t2, $t2, 4
	j draw_sprite_loop_over_x

draw_sprite_end_loop_over_x:
	# ++y
	addi $a1, $a1, 1
	# x = initial x
	move $a0, $t5
	# Advance pixels cursor
	sll $t5, $t3, 2
	add $t2, $t2, $t5	# += 4 * left sprite x
	j draw_sprite_loop_over_y
	
draw_sprite_end_loop_over_y:
draw_sprite_end:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
