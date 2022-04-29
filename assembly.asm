.data
	a: .word 1, 2, 3, 8
	sum: .asciiz "sum is : "

.text
.globl main

#=====Block Begin=====
main:
	lui $s0, 0x1001
#=====Arithmetic Assignment=====
	li $t1, 4
	li $t2, 1
	mul $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 0($s0)	#T1
#=====Arithmetic Assignment=====
	li $t1, 4
	li $t2, 0
	mul $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 4($s0)	#T2
#=====Arithmetic Assignment=====
	lw $t2, 0($s0)	# T1
	li $t1, 2
	mul $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 12($s0)	#T3
#=====Arithmetic Assignment=====
	lw $t1, 4($s0)	# T2
	lw $t2, 12($s0)	# T3
	lw $t1, 4($s0)
	lw $t2, 12($s0)
	add $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 24($s0)	#T4
#=====Assignment=====
	lw $t0, 24($s0)
	lw $t0, a($t0)
	sw $t0, 28($s0)	#T5
#=====Assignment=====
	lw $t0, 28($s0)	# T5
	sw $t0, 32($s0)	#tempx
#=====Arithmetic Assignment=====
	li $t1, 4
	li $t2, 1
	mul $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 36($s0)	#T6
#=====Arithmetic Assignment=====
	li $t1, 4
	li $t2, 1
	mul $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 40($s0)	#T7
#=====Arithmetic Assignment=====
	lw $t2, 36($s0)	# T6
	li $t1, 2
	mul $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 48($s0)	#T8
#=====Arithmetic Assignment=====
	lw $t1, 40($s0)	# T7
	lw $t2, 48($s0)	# T8
	lw $t1, 40($s0)
	lw $t2, 48($s0)
	add $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 60($s0)	#T9
#=====Assignment=====
	lw $t0, 60($s0)
	lw $t0, a($t0)
	sw $t0, 64($s0)	#T10
#=====Assignment=====
	lw $t0, 64($s0)	# T10
	sw $t0, 68($s0)	#tempy
#=====Display=====
	li $v0, 1
	lw $v1, 32($s0)
	add $a0, $v1, $zero
	syscall
	li $v0 11
	li $a0, 0x20 
	syscall
	li $v0 11
	li $a0 10
	syscall
#=====Display=====
	li $v0, 1
	lw $v1, 68($s0)
	add $a0, $v1, $zero
	syscall
	li $v0 11
	li $a0, 0x20 
	syscall
	li $v0 11
	li $a0 10
	syscall
#=====Arithmetic Assignment=====
	lw $t1, 32($s0)	# tempx
	lw $t2, 68($s0)	# tempy
	lw $t1, 32($s0)
	lw $t2, 68($s0)
	add $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 80($s0)	#T11
#=====Assignment=====
	lw $t0, 80($s0)	# T11
	sw $t0, 84($s0)	#tempz
#=====Display=====
	li $v0, 4
	la $a0, sum 
	syscall
	li $v0 11
	li $a0, 0x20 
	syscall
	li $v0 11
	li $a0 10
	syscall
#=====Display=====
	li $v0, 1
	lw $v1, 84($s0)
	add $a0, $v1, $zero
	syscall
	li $v0 11
	li $a0, 0x20 
	syscall
	li $v0 11
	li $a0 10
	syscall

	jr $ra