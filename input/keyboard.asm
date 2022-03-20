# Keyboard input

.data

.align 2
keyboard_a_down:	.byte	0
keyboard_d_down:	.byte	0
keyboard_e_down:	.byte	0
keyboard_q_down:	.byte	0
keyboard_s_down:	.byte	0
keyboard_w_down:	.byte	0

.text

## void poll_keyboard(void)
## Poll the keyboard for keypresses and set/reset the appropriate
## `keyboard_X_down` flags.
poll_keyboard:
	# Clear flags
	sw $zero, keyboard_a_down
	sh $zero, keyboard_s_down
	
poll_keyboard_loop:
	lw $t0, 0xffff0000
	beqz $t0, poll_keyboard_done
	
	lw $t0, 0xffff0004
	li $t1, 1
	beq $t0, 0x61, poll_keyboard_found_a
	beq $t0, 0x64, poll_keyboard_found_d
	beq $t0, 0x65, poll_keyboard_found_e
	beq $t0, 0x71, poll_keyboard_found_q
	beq $t0, 0x73, poll_keyboard_found_s
	beq $t0, 0x77, poll_keyboard_found_w
	
	j poll_keyboard_loop

poll_keyboard_found_a:
	sb $t1, keyboard_a_down
	j poll_keyboard_loop
poll_keyboard_found_d:
	sb $t1, keyboard_d_down
	j poll_keyboard_loop
poll_keyboard_found_e:
	sb $t1, keyboard_e_down
	j poll_keyboard_loop
poll_keyboard_found_q:
	sb $t1, keyboard_q_down
	j poll_keyboard_loop
poll_keyboard_found_s:
	sb $t1, keyboard_s_down
	j poll_keyboard_loop
poll_keyboard_found_w:
	sb $t1, keyboard_w_down
	j poll_keyboard_loop
	
poll_keyboard_done:
	jr $ra
