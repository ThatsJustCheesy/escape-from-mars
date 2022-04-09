.data

sprite_activator:	.word	8, 8, 0x00010100, 0x00000001, 0x00010101, 0x00000100, 0x00010000, 0x00000000, 0x00000001, 0x00000000, 0x00000001, 0x00010001, 0x00010100, 0x00000000, 0x00000000, 0x00000100, 0x00010100, 0x00000101, 0x00010001, 0x00000000, 0x00010001, 0x00000001, 0x00010000, 0x00010001, 0x00000001, 0x00010101, 0x00000001, 0x00000101, 0x00010000, 0x00000100, 0x00010000, 0x00000100, 0x00010101, 0x00000001, 0x00000001, 0x00000000, 0xffff315e, 0xfffe315e, 0xffff315e, 0xffff305f, 0x00000001, 0x00000000, 0x00000101, 0xffff305e, 0xffff315e, 0xffff315e, 0xfffe305f, 0xfffe305f, 0xfffe305f, 0x00000101, 0x00010001, 0xff525253, 0xff535252, 0xff525253, 0xff525253, 0xff525252, 0xff525252, 0x00010100, 0xff535252, 0xff535252, 0xff535253, 0xff535353, 0xff525253, 0xff535253, 0xff525253, 0xff525252

.text

## void update_activator(object* self)
## Update function for activator objects.
update_activator:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $a0, $a0, 0	# object.bounds
	jal check_player_collision
	
	la $t8, t_collide_when_active
	la $t9, t_collide_when_inactive
	lw $t0, level_layout_tile.collision($t8)
	
	bnez $v0, update_activator_collision
	
update_activator_no_collision:
	beqz $t0, update_activator_end
	
	# Became inactive
	
	li $t1, 1
	sw $zero, level_layout_tile.collision($t8)
	sw $t1, level_layout_tile.collision($t9)
	
	la $t1, t_collide_when_active_inactive_sprite
	sw $t1, level_layout_tile.graphics($t8)
	la $t1, t_collide_when_inactive_inactive_sprite
	sw $t1, level_layout_tile.graphics($t9)
	
	j update_activator_redraw
	
update_activator_collision:
	bnez $t0, update_activator_end
	
	# Became active
	
	li $t1, 1
	sw $t1, level_layout_tile.collision($t8)
	sw $zero, level_layout_tile.collision($t9)
	
	la $t1, t_collide_when_active_active_sprite
	sw $t1, level_layout_tile.graphics($t8)
	la $t1, t_collide_when_inactive_active_sprite
	sw $t1, level_layout_tile.graphics($t9)
	
update_activator_redraw:
	jal clear
	lw $a0, current_level_layout
	jal draw_level
	
update_activator_end:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
