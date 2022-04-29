.data
	h: .asciiz "Hello World"

.text
.globl main

#=====Block Begin=====
helloWorld:
#=====Display=====
	li $v0, 4
	la $a0, h 
	syscall
	li $v0 11
	li $a0, 0x20 
	syscall
	li $v0 11
	li $a0 10
	syscall
#=====Jump=====
	j LhelloWorld
#=====Block Begin=====
main:
	lui $s0, 0x1001
#=====Jump=====
	j helloWorld
#=====Block Begin=====
LhelloWorld:

	jr $ra