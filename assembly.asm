.data

.text
.globl main

#=====Block Begin=====
main:
	lui $s0, 0x1001
#=====Assignment=====
	li $t0, 0
	sw $t0, 0($s0)	#sum
#=====Input=====
	li $v0, 5
	syscall
	move $t4, $v0
	sw $t4, 0($s0)	#sum
#=====Assignment=====
	lw $t0, 0($s0)	# sum
	sw $t0, 4($s0)	#T1
#=====Assignment=====
	li $t0, 0
	sw $t0, 8($s0)	#T2
#=====If Condition=====
	lw $t1, 4($s0)	# T1
	lw $t2, 8($s0)	# T2
	sub $t3, $t1, $t2
	beq $t3, $zero, L1
#=====Jump=====
	j L2
#=====Block Begin=====
L1:
#=====Assignment=====
	li $t0, 10
	sw $t0, 12($s0)	#T3
#=====Assignment=====
	lw $t0, 12($s0)	# T3
	sw $t0, 16($s0)	#a
#=====Jump=====
	j L3
#=====Block Begin=====
L2:
#=====Assignment=====
	lw $t0, 0($s0)	# sum
	sw $t0, 20($s0)	#T4
#=====Assignment=====
	li $t0, 10
	sw $t0, 24($s0)	#T5
#=====If Condition=====
	lw $t1, 20($s0)	# T4
	lw $t2, 24($s0)	# T5
	sub $t3, $t1, $t2
	beq $t3, $zero, L4
#=====Jump=====
	j L5
#=====Block Begin=====
L4:
#=====Assignment=====
	li $t0, 20
	sw $t0, 28($s0)	#T6
#=====Assignment=====
	lw $t0, 28($s0)	# T6
	sw $t0, 16($s0)	#a
#=====Jump=====
	j L3
#=====Block Begin=====
L5:
#=====Assignment=====
	li $t0, 30
	sw $t0, 32($s0)	#T7
#=====Assignment=====
	lw $t0, 32($s0)	# T7
	sw $t0, 16($s0)	#a
#=====Block Begin=====
L3:
#=====Display=====
	li $v0, 1
	lw $v1, 16($s0)
	add $a0, $v1, $zero
	syscall
	li $v0 11
	li $a0, 0x20 
	syscall
	li $v0 11
	li $a0 10
	syscall

	jr $ra