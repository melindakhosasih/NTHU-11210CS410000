.data
	input_x	:	.asciiz	"input x: "
	input_y	:	.asciiz "input y: "
	input_z	:	.asciiz "input z: "
	result	:	.asciiz "result = "	
	n_line	: 	.asciiz "\n"

.text
.globl main

main:
	# Print
	li $v0, 4		# syscall code to print string
	la $a0, input_x		# load input_x string
	syscall			# print
	
	# Scan
	li $v0, 5 		# syscall code to read integer
	syscall			# scan
	add $t0, $v0, 0		# $t0 = x
	
	# Print
	li $v0, 4		# syscall code to print string
	la $a0, input_y		# load input_y string
	syscall			# print
	
	# Scan
	li $v0, 5		# syscall code to read integer
	syscall			# scan
	add $t1, $v0, 0		# $t1 = y
	
	# Print
	li $v0, 4 		# sycall code to print string
	la $a0, input_z		# load input_z string
	syscall			# print
	
	# Scan
	li $v0, 5		# syscall code to read integer
	syscall			# scan
	add $t2, $v0, 0		# $t2 = z
	
	add $a0, $t0, 0		# $a0 = $t0 = x
	add $a1, $t1, 0		# $a1 = $t1 = y
	jal compare		# jump and link to compare
	
	add $a0, $v0, 0		# $a0 = $v0 = result of compare
	add $a1, $t2, 0		# $a1 = $t2 = z
	jal smod		# jump and link to smod
	add $t0, $v0, 0		# $t0 = $v0 = result of smod
	
	# Print
	li $v0, 4		# sycall code to print string
	la $a0, result		# load result string
	syscall			# print
	
	# Print
	li $v0, 1		# sycall code to print string
	add $a0, $t0, 0		# load $t0 (result of smod)
	syscall			# print
	
	# Print
	li $v0, 4		# sycall code to print string
	la $a0, n_line		# load result string
	syscall			# print
	
	j exit			# jump to exit
	
compare:
	bgtu $a0, $a1, sum	# if p > q -> $a0 > $a1 -> jump to sum
	add $v0, $a0, 0 	# else if p <= q -> $a0 <= $a1 -> result = $a0 = p
	jr $ra			# jump back to jal compare
	
sum:
	add $v0, $a0, $a1	# result = $a0 + $a1 = p + q
	jr $ra			# jump back to jal compare
	
smod:
	li $t0, 4		# load integer
	bgtu $a0, $a1, div_p	# if p > q -> $a0 > $a1 -> jump to div_p
	j div_q			# else if p <= q -> $a0 <= $a1 -> jump to div_q
	
div_p:
	div $a0, $t0		# $a0 / $t0 = p / 4
	mfhi $t0		# $t0 = $a0 % 4 = p % 4
	
	addi $sp, $sp, -4	# $sp -= 4
	sw $ra, 0($sp)		# store $ra in stack
	
	jal pow			# jump and link to pow
	
	lw $ra, 0($sp)		# load $ra from stack
	addi $sp, $sp, 4	# $sp += 4
	
	addi $t0, $v0, 2	# $t0 = 2 + pow(2, p % 4)
	j compute		# jump to compute
	
div_q:
	div $a1, $t0		# $a1 / $t0 = q / 4
	mfhi $t0		# $t0 = $a1 % 4 = q % 4
	
	addi $sp, $sp, -4	# $sp -= 4
	sw $ra, 0($sp)		# store $ra (smod) in stack
	
	jal pow			# jump and link to pow
	
	lw $ra, 0($sp)		# load $ra (smod) from stack
	addi $sp, $sp, 4	# $sp += 4
	
	addi $t0, $v0, 4	# $t0 = 4 + pow(2, q % 4)
	j compute		# jump to compute
	
compute:
	mul $t0, $t0, 5		# $t0 = div = $t0 * 5
	mul $t1, $a0, 4		# $t1 = divd = $a0 * 4 = p * 4
	add $t1, $t1, $a1	# $t1 = divd = $t1 + $a1 = p * 4 + q
	div $t1, $t0		# $t1 / $t0 = divd / div
	mfhi $v0		# result = $t1 % $t0 = divd $ div
	jr $ra			# jump back to jal smod
	
pow:
	li $t1, 1		# $t1 = 1 = pow_res
	j pow_loop		# jump to power loop

pow_loop:
	beqz $t0, pow_done	# if $t0 == 0 -> done
	mul $t1, $t1, 2		# $t1 = $t1 * 2 = pow_res
	addi $t0, $t0, -1	# $t0 -= 1
	j pow_loop		# compute loop until end

pow_done:
	add $v0, $t1, 0		# result = $t0
	jr $ra			# jump back to jal pow
	
exit:
	li $v0, 10		# syscall code to exit
	syscall			# exit
	

