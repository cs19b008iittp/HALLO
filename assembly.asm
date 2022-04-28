.data

.text
.globl main

#=====Block Begin=====
main:
	lui $s0, 0x1001
#=====Assignment=====
	li $t0, 0
	sw $t0, 0($s0)	#sum
#=====Assignment=====
	li $t0, 1
	sw $t0, 4($s0)	#prod
#=====Assignment=====
	li $t0, 0
	sw $t0, 8($s0)	#diff
#=====Assignment=====
	li $t0, 0
	sw $t0, 12($s0)	#quotient
#=====Assignment=====
	lw $t0, 0($s0)	# sum
	sw $t0, 16($s0)	#T1
#=====Assignment=====
	li $t0, 0
	sw $t0, 20($s0)	#T2
#=====If Condition=====
	lw $t1, 16($s0)	# T1
	lw $t2, 20($s0)	# T2
	sub $t3, $t1, $t2
	beq $t3, $zero, L1
#=====Jump=====
	j L2
#=====Block Begin=====
L1:
#=====Assignment=====
	li $t0, 10
	sw $t0, 24($s0)	#d
#=====Assignment=====
	lw $t0, 24($s0)	# d
	sw $t0, 28($s0)	#T3
#=====Assignment=====
	li $t0, 10
	sw $t0, 32($s0)	#T4
#=====If Condition=====
	lw $t1, 28($s0)	# T3
	lw $t2, 32($s0)	# T4
	sub $t3, $t1, $t2
	beq $t3, $zero, L3
#=====Jump=====
	j L4
#=====Block Begin=====
L3:
#=====Assignment=====
	li $t0, 5
	sw $t0, 36($s0)	#T5
#=====Assignment=====
	lw $t0, 36($s0)	# T5
	sw $t0, 24($s0)	#d
#=====Assignment=====
	li $t0, 100
	sw $t0, 40($s0)	#c
#=====Arithmetic Assignment=====
	lw $t1, 40($s0)	# c
	add $t3, $t1, 5
	add $t0, $t3, $zero
	sw $t0, 48($s0)	#T6
#=====Assignment=====
	lw $t0, 48($s0)	# T6
	sw $t0, 24($s0)	#d
#=====Jump=====
	j L5
#=====Block Begin=====
L4:
#=====Assignment=====
	li $t0, 7
	sw $t0, 52($s0)	#T7
#=====Assignment=====
	lw $t0, 52($s0)	# T7
	sw $t0, 24($s0)	#d
#=====Block Begin=====
L5:
#=====Assignment=====
	li $t0, 10
	sw $t0, 56($s0)	#a
#=====Arithmetic Assignment=====
	lw $t1, 24($s0)	# d
	lw $t2, 40($s0)	# c
	add $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 68($s0)	#T8
#=====Assignment=====
	lw $t0, 68($s0)	# T8
	sw $t0, 56($s0)	#a
#=====Assignment=====
	li $t0, 20
	sw $t0, 72($s0)	#T9
#=====Assignment=====
	lw $t0, 72($s0)	# T9
	sw $t0, 40($s0)	#c
#=====Jump=====
	j L7
#=====Block Begin=====
L2:
#=====Assignment=====
	lw $t0, 0($s0)	# sum
	sw $t0, 76($s0)	#T10
#=====Assignment=====
	li $t0, 10
	sw $t0, 80($s0)	#T11
#=====If Condition=====
	lw $t1, 76($s0)	# T10
	lw $t2, 80($s0)	# T11
	sub $t3, $t1, $t2
	beq $t3, $zero, L8
#=====Jump=====
	j L9
#=====Block Begin=====
L8:
#=====Assignment=====
	li $t0, 20
	sw $t0, 84($s0)	#T12
#=====Assignment=====
	lw $t0, 84($s0)	# T12
	sw $t0, 56($s0)	#a
#=====Jump=====
	j L7
#=====Block Begin=====
L9:
#=====Assignment=====
	li $t0, 30
	sw $t0, 88($s0)	#T13
#=====Assignment=====
	lw $t0, 88($s0)	# T13
	sw $t0, 56($s0)	#a
#=====Block Begin=====
L7:
#=====Display=====
	li $v0, 1
	lw $v1, 56($s0)
	add $a0, $v1, $zero
	syscall
	li $v0, 1
	lw $v1, 40($s0)
	add $a0, $v1, $zero
	syscall
	li $v0, 1
	lw $v1, 24($s0)
	add $a0, $v1, $zero
	syscall

	jr $ra