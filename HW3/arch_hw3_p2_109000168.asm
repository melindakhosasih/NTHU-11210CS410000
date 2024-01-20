.data
	input	:	.asciiz	"Please input the total number of the disks: "
	mv_disk	:	.asciiz "Move disk "
	from	:	.asciiz " from "
	to	:	.asciiz " to "
	total	:	.asciiz "Total number of movement = "
	n_line	: 	.asciiz "\n"

.text
.globl main

main:
	# Print input
	li $v0, 4		# syscall code to print string
	la $a0, input		# load input string
	syscall			# print
	
	# Scan numDis
	li $v0, 5 		# syscall code to read integer
	syscall			# scan
	add $a0, $v0, 0		# $a0 = numDisks
	addi $a0, $a0, -1	# $a0 -= 1 (numDisk -=1)
	
	li $s0, 0		# Initialize $s0 = cnt = 0
	li $a1, 'A'		# $a1 = A
	li $a2, 'B'		# $a2 = B
	li $a3, 'C'		# $a3 = C
	
	jal MoveTower		# jump and link to MoveTower
	
	# Print
	li $v0, 4		# syscall code to print string
	la $a0, total		# load total string
	syscall			# print
	
	# Print
	li $v0, 1		# syscall code to print string
	add $a0, $s0, 0		# load cnt
	syscall			# print
	
	# Print
	li $v0, 4		# syscall code to print string
	la $a0, n_line		# load n_line string
	syscall			# print
	
	j exit			# jump to exit
	
MoveTower:
	# Store address and arguments
	addi $sp, $sp, -20	# $sp -= 20
	sw $ra, 16($sp)		# store $ra in stack
	sw $a0, 12($sp)		# store disk in stack
	sw $a1, 8($sp)		# store source in stack
	sw $a2, 4($sp)		# store dest in stack
	sw $a3, 0($sp)		# store spare in stack
	
	beqz $a0, base		# if $a0 = 0 (disk = 0) -> base
	
	addi $a0, $a0, -1	# $a0 -= 1 (disk -= 1)
	add $t0, $a2, 0		# $t0 = temp = $a2
	add $a2, $a3, 0		# $a2 = $a3
	add $a3, $t0, 0		# $a3 = temp
	
	jal MoveTower		# jump and link to MoveTower	
	jal print		# jump and link to print
	
	lw $ra, 16($sp)		# load $ra from stack
	lw $a0, 12($sp)		# load disk from stack
	lw $a1, 8($sp)		# load source from stack
	lw $a2, 4($sp)		# load dest from stack
	lw $a3, 0($sp)		# load spare from stack
	
	addi $a0, $a0, -1	# $a0 -= 1 (disk -= 1)
	add $t0, $a1, 0		# $t0 = temp = $a1
	add $a1, $a3, 0		# $a1 = $a3
	add $a3, $t0, 0		# $a3 = temp
	
	jal MoveTower		# jump and link to MoveTower
	
	lw $ra, 16($sp)		# load $ra from stack
	addi $sp, $sp, 20	# $sp += 20
	jr $ra			# jump back to caller
	
base:
	jal print		# jump and link to print
	
	lw $ra, 16($sp)		# load $ra from stack
	lw $a0, 12($sp)		# load disk from stack
	lw $a1, 8($sp)		# load source from stack
	lw $a2, 4($sp)		# load dest from stack
	lw $a3, 0($sp)		# load spare from stack
	addi $sp, $sp, 20	# $sp += 20

	jr $ra			# jump back to caller
	
print:
	lw $t0, 12($sp)		# load disk from stack
	lw $t1, 8($sp)		# load source from stack
	lw $t2, 4($sp)		# load dest from stack
	lw $t3, 0($sp)		# load spare from stack
	
	# Print "Move disk"
	li $v0, 4		# syscall code to print string
	la $a0, mv_disk		# load mv_disk string
	syscall			# print
	
	# Print disk
	li $v0, 1		# syscall code to print integer
	add $a0, $t0, 0		# load disk
	syscall			# print
	
	# Print "from"
	li $v0, 4		# syscall code to print string
	la $a0, from		# load from string
	syscall			# print
	
	# Print source
	li $v0, 11		# syscall code to print char
	add $a0, $t1, 0		# load source
	syscall			# print
	
	# Print "to"
	li $v0, 4		# syscall code to print string
	la $a0, to		# load to string
	syscall			# print
	
	# Print dest
	li $v0, 11		# syscall code to print char
	add $a0, $t2, 0		# load dest
	syscall			# print
	
	# Print n_line
	li $v0, 4		# syscall code to print string
	la $a0, n_line		# load n_line string
	syscall			# print
	
	addi $s0, $s0, 1	# $s0++ (cnt++)
	
	jr $ra			# jump back to caller
		
exit:
	li $v0, 10		# syscall code to exit
	syscall			# exit
	

