# Bitmap Display Configuration:
# - Unit width in pixels: 4
# - Unit height in pixels: 4
# - Display width in pixels: 512
# - Display height in pixels: 256
# - Base Address for Display: 0x10010000 (static data)

.eqv	FB_BASE	0x10010000
.eqv	FB_LEN	0x8000

.eqv	DISPLAY_WIDTH	128	# 512 / 4
.eqv	DISPLAY_HEIGHT	64	# 256 / 4

.data
fb:	.space	0x8000

.text

## int xy2offset(int x, int y)
## Convert (x,y)-based coordinates to a framebuffer offset.
xy2offset:
	# Formula: offset = 4 * (x + (y * DISPLAY_WIDTH))
	mul $v0, $a1, DISPLAY_WIDTH
	add $v0, $v0, $a0
	sll $v0, $v0, 2
	jr $ra


## void clear(void)
## Clear the screen.
clear:	li $t0, FB_BASE
	addi $t1, $t0, FB_LEN
	li $t2, BACKGROUND_COLOR
	
clear_loop:
	beq $t0, $t1, clear_end
	
	#sub $t2, $t1, $t0
	#andi $t2, $t2, 0x00FF00
	
	sw $t2, ($t0)
	
	addi $t0, $t0, 4
	j clear_loop
	
clear_end:
	jr $ra
