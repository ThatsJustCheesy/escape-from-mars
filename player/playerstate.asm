.eqv REALPLAYER_INITIAL_X 15
.eqv REALPLAYER_INITIAL_Y 110

.data

current_players:	.word	0:17	## 1 for count, plus (player*)[16]

.eqv current_players.count 0
.eqv current_players.players 4

.text

## void reset_players(void)
## Remove all scripted players and reset the real player's state.
reset_players:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# Reset count
	la $t0, current_players
	li $t1, 1
	sw $t1, 0($t0)
	
	# Recreate real player
	li $a0, REALPLAYER_INITIAL_X
	li $a1, REALPLAYER_INITIAL_Y
	jal new_realplayer
	la $t0, current_players
	sw $v0, current_players.players($t0)
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra


## void update_players(void)
## Trigger updates for all players.
update_players:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	
	# s0 = counter
	la $t0, current_players
	lw $s0, current_players.count($t0)
	
	# s1 = cursor into current_players
	la $s1, current_players
	addi $s1, $s1, current_players.players
	
update_players_loop:
	beqz $s0, update_players_end
	
	lw $a0, 0($s1)
	jal update_object
	
	addi $s1, $s1, 4
	
	addi $s0, $s0, -1
	j update_players_loop
	
update_players_end:
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra


## void load_player(player*)
## Copy the given player to the current list of players.
load_player:
	# Increment count
	lw $t0, current_players
	addi $t0, $t0, 1
	sw $t0, current_players

	# Compute next empty slot address
	la $t1, current_players
	addi $t1, $t1, current_players.players
	addi $t0, $t0, -1
	sll $t0, $t0, 2
	add $t1, $t1, $t0
	
	# Put player pointer in empty slot
	sw $a0, ($t1)
	
	jr $ra
