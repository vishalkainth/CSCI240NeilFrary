#######################################################################################################################
#	Program Name: Sum of Integers
#	Programmer: VISHAL KAINTH
#	Date Last Modified: April 8th, 2021
#	Project: 2
#######################################################################################################################
# Functional description of algorithm: 
# A program to find the sum of the integers from 1 to N, where N is a value read in from the keyboard.
# “Fix” the program and allow for a floating point number to be entered.
#######################################################################################################################
# Cross References:
# v0: N,
# t0: Sum
#######################################################################################################################
	
	.data
Prompt:	.asciiz		"\n Please Input a value for N = "
fp:	.asciiz		"\n You entered a Floating Point number. It has been truncated and we will be using: "
Result: .asciiz 	"\n The sum of the integers from 1 to N is: "
Bye:	.asciiz 	"\n *** Adios Amigo - Have a good day *** " 
	.globl 	main
	
	.text
main:
	li		$v0, 4			# system call code for Print String 
	la 		$a0, Prompt		# load address of prompt into $a0
	syscall					# print the prompt message
	li		$v0, 6			# system call code for Read Integer
	syscall					# reads the value of N into $v0
	li		$t0, 0			# clear register $t0 to 0
		
	mfc1 		$t1, $f0		# move floating point number into intger register
	srl 		$t2, $t1, 23		# logical shift of 0
	add 		$s3, $t2, -127		# subtract 127 to get the exponent
	sll		$t4, $t1, 9		# shift out exponent and sign bit
	srl 		$t5, $t4, 9		# shift back to original postion, making all the bits 0
	add		$t6, $t5, 8388608	# add the implied bit to bit number 8 (2^23)
	add		$t7, $s3, 9		# add 9 to the exponent
	sllv 		$s4, $t6, $t7		# by shifting to the left 9 + exponent. if the number N is 0 then there is a fraction. shifted out the integer
	rol		$t4, $t6, $t7		# rotate the bits left by $t7 to get the integer postion in the right most bits
	li		$t5, 31			# shift left 31 -exp to zero out the other bits
	sub		$t2, $t5, $s3		# shift value
	sllv 		$t5, $t4, $t2		# zero out the fraction part
	srlv		$s5, $t5, $t2		# reset interger bits. integer is in $s5
	move		$v0, $s5		# move the integer into V0
	
	li 		$t0, 0			# zero out $t0	
	blez		$t1, End		# branch to end if 0, this is the integer of the floating point value entered
	beqz		$s4, Loop		# branch to loop if no floating point entered
	li		$v0, 4			# syscall print string
	la		$a0, fp			# load address of Prompt to $a0
	syscall					# print the string
	li		$v0, 1			# print integer setup
	move		$a0, $s5		# move value to be printed to $a0
	syscall					# print the string
	move 		$v0, $s5		# move the value of s5 sinve v0 cointains a 4 from the syscall

Loop:
	add		$t0, $t0, $v0		# sum of integers in register $t0
	addi		$v0, $v0, -1		# summing integers in reverse order
	bnez		$v0, Loop		# branch to loop if $v0 is != 0
	
	li 		$v0, 4			# system call code for Print String
	la 		$a0, Result		# load address of message into $a0
	syscall					# print the string
	
	li		$v0, 1			# system call code for Print Integer
	move 		$a0, $t0		# move value to be printed to $a0
	syscall					# print sum of integers
	b		main			# branch to main

End: 	li 		$v0, 4			# system call code for Print String
	la 		$a0, Bye		# load address of msg. into $a0
	syscall					# print the string
	li		$v0, 10			# terminate program run and
	syscall					# return control to system
