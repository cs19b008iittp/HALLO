.data

.text
.globl main

#=====Block Begin=====
value_b:
#=====Assignment=====
	li $t0, 20
	sw $t0, 0($s0)	#T1
#=====Assignment=====
	lw $t0, 0($s0)	# T1
	sw $t0, 4($s0)	#b
	lw $t6, 4($s0)
#=====Jump=====
	j Lvalue_b
#=====Block Begin=====
main:
	lui $s0, 0x1001
#=====Assignment=====
	li $t0, 10
	sw $t0, 8($s0)	#T2
#=====Assignment=====
	lw $t0, 8($s0)	# T2
	sw $t0, 12($s0)	#a
#=====Jump=====
	j value_b
#=====Block Begin=====
Lvalue_b:
#=====Assignment=====
	add $t0, $t6, $zero	# func
	sw $t0, 4($s0)	#b
#=====Display=====
	li $v0, 1
	lw $v1, 12($s0)
	add $a0, $v1, $zero
	syscall
#=====Display=====
	li $v0, 1
	lw $v1, 4($s0)
	add $a0, $v1, $zero
	syscall

	jr $ra