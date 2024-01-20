.data
	input:	.asciiz	"Please enter a number(Input 0 to exit): "
	output:	.asciiz	"The Roman is: "
	n_line: .asciiz "\n"
	end:	.asciiz "bye"
	symbol: 
		.word M, CM, D, CD, C, XC, L, XL, X, IX, V, IV, I
	val:
		.word 1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1
	ans:	.space 100
	I:	.asciiz "I"
	IV:	.asciiz "IV"
	V:	.asciiz "V"
	IX:	.asciiz "IX"
	X:	.asciiz "X"
	XL:	.asciiz "XL"
	L:	.asciiz "L"
	XC:	.asciiz "XC"
	C:	.asciiz "C"
	CD:	.asciiz "CD"
	D:	.asciiz "D"
	CM:	.asciiz "CM"
	M:	.asciiz "M"

.text
.globl main

main:
	# Print
	li $v0, 4		# syscall code to print string
	la $a0, input		# load string
	syscall			# print
	
	# Scan
	li $v0, 5 		# syscall code to read integer
	syscall			# scan
	add $t0, $v0, 0		# $t0 = input = num
	
	# Check if input is 0
	beqz $t0, exit		# if num = 0, print bye
	
	la $t1, symbol		# load symbol
	la $t2, val		# load val
	la $s0, ans		# load ans for tail
	la $s1, ans		# load ans
	j loop			# jump to loop
	
loop:
	beqz $t0, done		# if num == 0 -> done
	lw $t3, ($t2)		# A = $t3 = val[i]
	lw $t4, ($t1)		# B = $t4 = symbol[i]
	div $t0, $t3		# num / val[i]
	mflo $t5		# n = $t5 = num / val[i]
	bge $t0, $t3, compute	# if (val[i] <= num) -> compute
	j increase		# increase val and symbol iteration
	
increase:
	addi $t2, $t2, 4	# val[i+1]
	addi $t1, $t1, 4	# symbol[i+1]
	j loop			# jump to loop
	
compute:
	mfhi $t0		# num = $t0 = remainder
	beqz $t5, loop		# n != 0
	sw $t4, ($s0)		# ans.insert(symbol[i])
	addi $t5, $t5, -1	# n--
	addi $s0, $s0, 4	# ans[i+1]
	j compute		# recursive

printNewLine:
	# Print new line
	li $v0, 4		# syscall code to print string
	la $a0, n_line		# load new line
	syscall			# print new line
	
	# return to main
	j main			# jump to main

printAns:
	lw $a0, ($s1)		# move answer to argument
	sw $zero, ($s1)		# store to ans
	beqz $a0, printNewLine	# if reach the end, print new line
	
	# Print
	li $v0, 4		# sycall code to print string
	syscall			# print	ans[i]
	
	addi $s1, $s1, 4	# move to next word ans[i+1]
	j printAns		# recursive
	
done:
	# Print output format
	li $v0, 4		# syscall code to print string
	la $a0, output		# load string
	syscall			# print
	
	# Print answer
	j printAns		# print answer
	
exit:
	# Print bye
	li $v0, 4		# syscall code to print string
	la $a0, end		# load string
	syscall			# print
	
	li $v0, 10		# syscall code to exit
	syscall			# exit
	
