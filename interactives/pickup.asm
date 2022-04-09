.data

sprite_ender:	.word	8, 8, 0xff6102a2, 0x00000000, 0xff6102a2, 0x00010100, 0xff6102a3, 0x00000100, 0xff6103a3, 0x00010100, 0x00000101, 0xff6002a3, 0x00000101, 0x00000101, 0xff6e01bb, 0xff6003a2, 0x00010100, 0x00010100, 0x00000001, 0xff6102a3, 0xff6e00bb, 0xff6f01ba, 0xff7f07d4, 0xff6e00bb, 0x00000100, 0x00000100, 0x00000100, 0xff6f01ba, 0xff7f07d5, 0xffc394e3, 0xffc395e3, 0xff7f06d4, 0xff6e01ba, 0xff6e01ba, 0x00000100, 0x00010100, 0xff6f00ba, 0xffc294e2, 0xffc294e2, 0xff7e07d5, 0x00000000, 0xff6102a3, 0xff6102a3, 0x00010000, 0xff6f01bb, 0xff7e07d4, 0xff7e07d5, 0xff6e00bb, 0x00000100, 0x00000101, 0x00000100, 0xff6f01ba, 0xff6f01ba, 0x00000101, 0x00010001, 0xff6e00bb, 0xff6103a2, 0x00010101, 0x00010001, 0xff6003a3, 0x00000100, 0x00000101, 0xff6003a3, 0xff6f00ba, 0x00010100, 0xff6103a3
sprite_cloner:	.word	8, 8, 0x00010101, 0x00010000, 0xff2496d2, 0xff2796d2, 0xff2497d5, 0x00000001, 0x00000100, 0x00000000, 0x00010000, 0xff2699d2, 0xff3ba5dd, 0xff3ba4dd, 0xff3aa4dd, 0xff2496d4, 0x00000101, 0x00000101, 0xff2596d5, 0xff3aa4dd, 0xff3ba4dd, 0xff3ba5dd, 0xff3ba5dd, 0x00000101, 0x00000001, 0x00000100, 0xff2697d3, 0xff3ba4dc, 0x00000100, 0x00000001, 0x00010000, 0x00010001, 0x00010001, 0xff3ba4dc, 0xff3aa5dd, 0x00000001, 0x00000100, 0x00010101, 0x00000001, 0x00010000, 0xff3aa4dd, 0xff2496d4, 0x00000100, 0x00000001, 0x00000101, 0xff3aa4dc, 0xff3aa5dd, 0xff3aa4dc, 0xff3ba4dd, 0xff2597d5, 0x00010001, 0x00010101, 0xff2497d5, 0xff3aa5dd, 0xff3ba4dd, 0xff3ba5dc, 0xff2596d5, 0x00010000, 0x00010001, 0x00000101, 0x00010001, 0xff2597d5, 0xff2499d5, 0xff2596d2, 0x00000001, 0x00000101
sprite_timecloner:	.word	8, 8, 0xff3e24d3, 0x00010101, 0x00010100, 0xff5139dc, 0xff5038dd, 0x00000100, 0x00010000, 0xff3f25d2, 0x00010000, 0xff3e24d3, 0xff5039dd, 0xff5e54e3, 0xff5e55e2, 0xff5039dd, 0xff5138dc, 0x00000000, 0xff5139dc, 0xff5f54e3, 0xff5e55e3, 0xff5e55e3, 0x00000100, 0x00000101, 0x00000001, 0x00010101, 0xff3f25d3, 0xff5e55e2, 0x00000000, 0x00010000, 0x00010000, 0x00010100, 0x00000001, 0xff5f55e3, 0xff5e55e2, 0x00000101, 0x00000101, 0x00000101, 0x00000000, 0x00010100, 0xff5e54e3, 0xff5039dd, 0x00010000, 0x00010100, 0x00010100, 0x00000100, 0xff5e54e3, 0xff5e55e2, 0xff5f55e3, 0xff3e24d2, 0x00010000, 0x00000001, 0xff5039dd, 0xff5e54e2, 0xff5e54e2, 0xff5e55e2, 0xff5139dd, 0x00000000, 0xff3720b8, 0xff5038dd, 0x00000001, 0xff5038dc, 0xff5039dd, 0xff3e25d3, 0x00000100, 0x00000001

.text

## void update_ender(object* self)
## Update function for ender pickups.
update_ender:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	addi $a0, $a0, object.bounds
	jal check_player_collision
	
	beqz $v0, update_ender_end
	
	jal advance_level
	
update_ender_end:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra


## void update_timecloner(object* self)
## Update function for timecloner pickups.
update_timecloner:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	addi $a0, $a0, object.bounds
	jal check_player_collision
	
	beqz $v0, update_cloner_end
	
	addi $sp, $sp, -4
	lw $t0, current_input_script
	sw $t0, 0($sp)
	
	# jal terminate_input_recording
	
	# li $a0, REALPLAYER_INITIAL_X
	# li $a1, REALPLAYER_INITIAL_Y
	# jal new_realplayer
	
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	
	li $a0, REALPLAYER_INITIAL_X
	li $a1, REALPLAYER_INITIAL_Y
	move $a2, $t0	# input_script*
	jal new_scriptedplayer
	
	move $a0, $v0
	jal load_player
	
	lw $a0, 0($sp)
	jal unload_object
	
update_timecloner_end:
	addi $sp, $sp, 4	# pop self pointer
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra


## void update_cloner(object* self)
## Update function for cloner pickups.
update_cloner:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	addi $sp, $sp, -4
	sw $a0, 0($sp)

	addi $a0, $a0, object.bounds
	jal check_player_collision

	beqz $v0, update_cloner_end

	li $a0, REALPLAYER_INITIAL_X
	li $a1, REALPLAYER_INITIAL_Y
	jal new_realplayer

	move $a0, $v0
	jal load_player

	lw $a0, 0($sp)
	jal unload_object

update_cloner_end:
	addi $sp, $sp, 4	# pop self pointer

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra
