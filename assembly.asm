.data
	te: .asciiz "Before swapping, values of a and b respectively are:"
	tem: .asciiz "After swapping, values of a and b respectively are:"

.text
.globl main

#=====Block Begin=====
main:
	lui $s0, 0x1001
#=====Assignment=====
	li $t0, 10
	sw $t0, 0($s0)	#a
#=====Assignment=====
	li $t0, 20
	sw $t0, 4($s0)	#b
#=====Display=====
	li $v0, 4
	la $a0, te 
	syscall
	li $v0 11
	li $a0, 0x20 
	syscall
	li $v0 11
	li $a0 10
	syscall
#=====Display=====
	li $v0, 1
	lw $v1, 0($s0)
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
	lw $v1, 4($s0)
	add $a0, $v1, $zero
	syscall
	li $v0 11
	li $a0, 0x20 
	syscall
	li $v0 11
	li $a0 10
	syscall
#=====Assignment=====
	lw $t0, 0($s0)	# a
	sw $t0, 8($s0)	#T1
#=====Assignment=====
	lw $t0, 8($s0)	# T1
	sw $t0, 12($s0)	#temp
#=====Assignment=====
	lw $t0, 4($s0)	# b
	sw $t0, 16($s0)	#T2
#=====Assignment=====
	lw $t0, 16($s0)	# T2
	sw $t0, 0($s0)	#a
#=====Assignment=====
	lw $t0, 12($s0)	# temp
	sw $t0, 20($s0)	#T3
#=====Assignment=====
	lw $t0, 20($s0)	# T3
	sw $t0, 4($s0)	#b
#=====Display=====
	li $v0, 4
	la $a0, tem 
	syscall
	li $v0 11
	li $a0, 0x20 
	syscall
	li $v0 11
	li $a0 10
	syscall
#=====Display=====
	li $v0, 1
	lw $v1, 0($s0)
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
	lw $v1, 4($s0)
	add $a0, $v1, $zero
	syscall
	li $v0 11
	li $a0, 0x20 
	syscall
	li $v0 11
	li $a0 10
	syscall

	jr $ra