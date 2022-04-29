.data
	arr: .word 64, 34, 25, 12, 22, 11, 90, 69

.text
.globl main

#=====Block Begin=====
main:
	lui $s0, 0x1001
#=====Assignment=====
	li $t0, 8
	sw $t0, 0($s0)	#size_arr
#=====Assignment=====
	li $t0, 0
	sw $t0, 4($s0)	#T1
#=====Arithmetic Assignment=====
	lw $t1, 0($s0)	# size_arr
	li $t2, 1
	sub $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 12($s0)	#T2
#=====Assignment=====
	li $t0, 1
	sw $t0, 16($s0)	#T3
#=====Assignment=====
	lw $t0, 4($s0)	# T1
	sw $t0, 20($s0)	#i
#=====Jump=====
	j L1
#=====Block Begin=====
L1:
#=====If Condition=====
	lw $t1, 4($s0)	# T1
	lw $t2, 12($s0)	# T2
	sub $t3, $t1, $t2
	blez $t3, L2
#=====Jump=====
	j L3
#=====Block Begin=====
L2:
#=====Assignment=====
	li $t0, 0
	sw $t0, 24($s0)	#T4
#=====Arithmetic Assignment=====
	lw $t1, 0($s0)	# size_arr
	lw $t2, 20($s0)	# i
	lw $t1, 0($s0)
	lw $t2, 20($s0)
	sub $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 36($s0)	#T5
#=====Arithmetic Assignment=====
	lw $t1, 36($s0)	# T5
	li $t2, 1
	sub $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 44($s0)	#T6
#=====Assignment=====
	li $t0, 1
	sw $t0, 48($s0)	#T7
#=====Assignment=====
	lw $t0, 24($s0)	# T4
	sw $t0, 52($s0)	#j
#=====Jump=====
	j L5
#=====Block Begin=====
L5:
#=====If Condition=====
	lw $t1, 24($s0)	# T4
	lw $t2, 44($s0)	# T6
	sub $t3, $t1, $t2
	blez $t3, L6
#=====Jump=====
	j L7
#=====Block Begin=====
L6:
#=====Arithmetic Assignment=====
	lw $t2, 52($s0)	# j
	li $t1, 4
	mul $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 60($s0)	#T8
#=====Assignment=====
	lw $t0, 60($s0)
	lw $t0, arr($t0)
	sw $t0, 64($s0)	#T9
#=====If Condition=====
	lw $t1, 4($s0)	# T1
	lw $t2, 12($s0)	# T2
	sub $t3, $t1, $t2
	bgez $t3, L9
#=====Jump=====
	j L10
#=====Block Begin=====
L9:
#=====Arithmetic Assignment=====
	lw $t2, 52($s0)	# j
	li $t1, 4
	mul $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 72($s0)	#T10
#=====Assignment=====
	lw $t0, 72($s0)
	lw $t0, arr($t0)
	sw $t0, 76($s0)	#T11
#=====Assignment=====
	lw $t0, 76($s0)	# T11
	sw $t0, 80($s0)	#temp
#=====Arithmetic Assignment=====
	lw $t2, 52($s0)	# j
	li $t1, 4
	mul $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 88($s0)	#T12
#=====Arithmetic Assignment=====
	lw $t1, 52($s0)	# j
	li $t2, 1
	add $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 96($s0)	#T13
#=====Arithmetic Assignment=====
	lw $t2, 96($s0)	# T13
	li $t1, 4
	mul $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 104($s0)	#T14
#=====Assignment=====
	lw $t0, 104($s0)
	lw $t0, arr($t0)
	sw $t0, 108($s0)	#T15
#=====Assignment=====
	lw $t0, 108($s0)	# T15
	sw $t0, 112($s0)	#arr(T12)
#=====Arithmetic Assignment=====
	lw $t1, 52($s0)	# j
	li $t2, 1
	add $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 120($s0)	#T16
#=====Arithmetic Assignment=====
	lw $t2, 120($s0)	# T16
	li $t1, 4
	mul $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 128($s0)	#T17
#=====Assignment=====
	lw $t0, 80($s0)	# temp
	sw $t0, 132($s0)	#T18
#=====Assignment=====
	lw $t0, 132($s0)	# T18
	sw $t0, 136($s0)	#arr(T17)
#=====Jump=====
	j L11
#=====Block Begin=====
L11:
#=====Block Begin=====
L10:
#=====Arithmetic Assignment=====
	lw $t1, 24($s0)	# T4
	lw $t2, 48($s0)	# T7
	lw $t1, 24($s0)
	lw $t2, 48($s0)
	add $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 24($s0)	#T4
#=====Assignment=====
	lw $t0, 24($s0)	# T4
	sw $t0, 52($s0)	#j
#=====Jump=====
	j L5
#=====Block Begin=====
L7:
#=====Arithmetic Assignment=====
	lw $t1, 4($s0)	# T1
	lw $t2, 16($s0)	# T3
	lw $t1, 4($s0)
	lw $t2, 16($s0)
	add $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 4($s0)	#T1
#=====Assignment=====
	lw $t0, 4($s0)	# T1
	sw $t0, 20($s0)	#i
#=====Jump=====
	j L1
#=====Block Begin=====
L3:
#=====Assignment=====
	li $t0, 0
	sw $t0, 156($s0)	#T19
#=====Arithmetic Assignment=====
	lw $t1, 0($s0)	# size_arr
	li $t2, 1
	sub $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 164($s0)	#T20
#=====Assignment=====
	li $t0, 1
	sw $t0, 168($s0)	#T21
#=====Assignment=====
	lw $t0, 156($s0)	# T19
	sw $t0, 20($s0)	#i
#=====Jump=====
	j L14
#=====Block Begin=====
L14:
#=====If Condition=====
	lw $t1, 156($s0)	# T19
	lw $t2, 164($s0)	# T20
	sub $t3, $t1, $t2
	blez $t3, L15
#=====Jump=====
	j L16
#=====Block Begin=====
L15:
#=====Arithmetic Assignment=====
	lw $t2, 20($s0)	# i
	li $t1, 4
	mul $t3, $t1, $t2
	add $t0, $t3, $zero
	sw $t0, 176($s0)	#T22
#=====Display=====
	li $v0, 1
	lw $v1, 52($s0)
	add $a0, $v1, $zero
	syscall
	li $v0 11
	li $a0, 0x20 
	syscall
	li $v0 11
	li $a0 10
	syscall

	jr $ra