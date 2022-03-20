## typedef struct bounding_box {
## 	int x0, y0, x1, y1;
## } bounding_box;

## bool check_collision(bounding_box* a, bounding_box* b)
## Check if bounding boxes `a` and `b` intersect.
check_collision:
	# Formula: (b.x0 <= a.x1 || a.x0 <= b.x1) && (b.y0 <= a.y1 || a.y0 <= b.y1)
	lw $t0, 0($a0)	# a.x0
	lw $t1, 4($a0)	# a.y0
	lw $t2, 8($a0)	# a.x1
	lw $t3, 12($a0)	# a.y1
	
	lw $t4, 0($a1)	# b.x0
	lw $t5, 4($a1)	# b.y0
	lw $t6, 8($a1)	# b.x1
	lw $t7, 12($a1)	# b.y1
	
	ble $t4, $t2, check_collision_x_success
	bgt $t0, $t6, check_collision_fail
	
check_collision_x_success:
	ble $t5, $t3, check_collision_success
	bgt $t1, $t7, check_collision_fail
	
check_collision_success:
	li $v0, 1
	jr $ra
	
check_collision_fail:
	li $v0, 0
	jr $ra
