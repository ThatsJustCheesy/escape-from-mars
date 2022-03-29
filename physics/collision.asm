## typedef struct bounding_box {
## 	int x0, y0, x1, y1;
## } bounding_box;

.eqv SIZEOF_bounding_box 16

.eqv bounding_box.x0 0
.eqv bounding_box.y0 4
.eqv bounding_box.x1 8
.eqv bounding_box.y1 12

.text

## bool check_collision(bounding_box* a, bounding_box* b)
## Check if bounding boxes `a` and `b` intersect.
check_collision:
	# Formula: (b.x0 <= a.x1 || a.x0 <= b.x1) && (b.y0 <= a.y1 || a.y0 <= b.y1)
	lw $t0, bounding_box.x0($a0)
	lw $t1, bounding_box.y0($a0)
	lw $t2, bounding_box.x1($a0)
	lw $t3, bounding_box.y1($a0)
	
	lw $t4, bounding_box.x0($a1)
	lw $t5, bounding_box.y0($a1)
	lw $t6, bounding_box.x1($a1)
	lw $t7, bounding_box.y1($a1)
	
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
