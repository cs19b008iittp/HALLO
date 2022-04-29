.data
	h: .asciiz "Hello World"

.text
.globl main

#=====Block Begin=====
main:
	lui $s0, 0x1001
#=====Display=====
	li $v0, 4
	la $a0, h 
	syscall
#=====Assignment=====
	li $t0, 10
	sw $t0, 0($s0)	#a
#=====Input=====
	li $v0, 5
	syscall
	move $t4, $v0
	sw $t4, 0($s0)	#a
#=====Display=====
	li $v0, 1
	lw $v1, 0($s0)
	add $a0, $v1, $zero
	syscall

	jr $ra