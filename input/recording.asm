.text

## void record_input(void)
## Record the player's current inputs to the global current input script.
record_input:
	lw $t0, current_input_script_cursor
	
	lw $t1, current_frame_index
	sw $t1, input_script_step.frame_index($t0)
	
	lb $t9, keyboard_a_down
	move $t8, $t9
	lb $t9, keyboard_q_down
	sll $t9, $t9, 1
	or $t8, $t8, $t9
	lb $t9, keyboard_d_down
	sll $t9, $t9, 2
	or $t8, $t8, $t9
	lb $t9, keyboard_e_down
	sll $t9, $t9, 3
	or $t8, $t8, $t9
	lb $t9, keyboard_w_down
	sll $t9, $t9, 4
	or $t8, $t8, $t9
	
	beqz $t8, record_input_end
	
	sh $t8, input_script_step.input($t0)
	
	addi $t0, $t0, SIZEOF_input_script_step
	sw $t0, current_input_script_cursor
	
record_input_end:
	jr $ra


# ## void terminate_input_recording(void)
# ## Write sentinel input 0xffff to the global current input script.
# terminate_input_recording:
# 	lw $t0, current_input_script_cursor
#
# 	lw $t1, current_frame_index
# 	sw $t1, input_script_step.frame_index($t0)
#
# 	li $t1, 0xffff
# 	sw $t1, input_script_step.input($t0)
#
# 	jr $ra
