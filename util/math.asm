## int min(int a, int b)
## Return the minimum of `a` and `b`.
min:	blt $a0, $a1, min_a_lt_b

	# b <= a
	move $v0, $a1
	jr $ra

min_a_lt_b:
	# a < b
	move $v0, $a0
	jr $ra

## int max(int a, int b)
## Return the maximum of `a` and `b`.
max:	bgt $a0, $a1, max_a_gt_b

	# b >= a
	move $v0, $a1
	jr $ra

max_a_gt_b:
	# a > b
	move $v0, $a0
	jr $ra
