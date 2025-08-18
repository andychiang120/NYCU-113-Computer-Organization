.data
	input_msg:	.asciiz "Enter a number: "
	output_msg:	.asciiz "Reversed number: "
	newline: 	.asciiz "\n"

.text
.globl main
#------------------------- main -----------------------------
main:
# print input_msg on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, input_msg		# load address of string into $a0
	syscall                 	# run the syscall
 
# read the input integer in $v0
	li      $v0, 5          	# call system call: read integer
	syscall                 	# run the syscall
	move    $a0, $v0      		# store input in $a0 (set arugument of procedure reverseNumber)

# jump to procedure reverseNumber
	jal 	reverseNumber
	move 	$t0, $v0			# save return value in t0 (because v0 will be used by system call) 

# print output_msg on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, output_msg		# load address of string into $a0
	syscall                 	# run the syscall

# print the result of procedure factorial on the console interface
	li 		$v0, 1				# call system call: print int
	move 	$a0, $t0			# move value of integer into $a0
	syscall 					# run the syscall

# print a newline at the end
	li		$v0, 4				# call system call: print string
	la		$a0, newline		# load address of string into $a0
	syscall						# run the syscall

# exit the program
	li 		$v0, 10				# call system call: exit
	syscall						# run the syscall

#------------------------- procedure reverseNumber -----------------------------
# load argument n in $a0, return value in $v0. 
.text
reverseNumber:
    addi 	$sp, $sp, -4		# allocate 4 byte to store $s0
	sw 		$s0, 0($sp)			# save the saved register
	add 	$s0, $0, $0			# set initial value of $s0
	li 		$t1, 10				# load 10 to $t1, do not write in loop
loop:
	ble 	$a0, $0, done		# if n <= 0 go to done
	mul 	$t0, $s0, 10		# $t0 = reversed * 10
	div 	$a0, $t1			# n div 10
	mflo 	$a0					# n = n / 10
	mfhi 	$t2					# $t2 = n % 10
	add 	$s0, $t0, $t2		# reversed = reversed * 10 + (n % 10)
	j 		loop				# jump to loop
done:
	add 	$v0, $s0, $0		# set return value #s0
	lw 		$s0, 0($sp)			# restore $s0
	addi 	$sp, $sp, 4			# deallocate stack
	jr 		$ra					# return to the caller