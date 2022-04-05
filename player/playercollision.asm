.text

## player* check_player_collision(bounding_box* bounds)
## Check if a player in the current player list intersects `bounds`.
## If there is such a player, return (a pointer to) it.
## Otherwise, return 0.
check_player_collision:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	# s0 = counter
	la $t0, current_players
	lw $s0, current_players.count($t0)
	
	# s1 = cursor into current_players
	la $s1, current_players
	addi $s1, $s1, 4	# current_players.players
	
	# s2 = bounds to check collisions for
	move $s2, $a0
	
check_player_collision_loop:
	beqz $s0, check_player_collision_not_found
	
	lw $a0, player.obj.bounds($s1)
	move $a1, $s2
	jal check_collision
	bnez $v0, check_player_collision_found
	
	addi $s1, $s1, 4
	
	addi $s0, $s0, -1
	j check_player_collision_loop

check_player_collision_found:
	move $v0, $s2
	j check_player_collision_end
	
check_player_collision_not_found:
	move $v0, $zero
	
check_player_collision_end:
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 12
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
