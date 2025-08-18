.data
	input_msg:	    .asciiz "Please input a number: "
	output_msg1:    .asciiz "The sum of Fibonacci(0) to Fibonacci("
    output_msg2:    .asciiz ") is:"
	newline: 	    .asciiz "\n"

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
	move    $a0, $v0      		# store input in $a0 (set arugument of procedure sum_of_fib)
    move    $t1, $v0            # store input in $t1 (show the argument in output msg)

# jump to procedure sum_of_fib
	jal 	fibonacciSum
	move 	$t0, $v0			# save return value in t0 (because v0 will be used by system call) 

# print output_msg1 on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, output_msg1	# load address of string into $a0
	syscall                 	# run the syscall

# print the highest Fibonacci index
    li      $v0, 1              # call system call: print int
    move    $a0, $t1            # store highest Fibonacci index to $a0
    syscall

# print output_msg2 on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, output_msg2	# load address of string into $a0
	syscall 

# print the result of procedure sum_of_fib on the console interface
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

#------------------------ procedure fibonacciSum ---------------------------
.text
fibonacciSum:
	addi	$sp, $sp, -12		# allocate 12 byte
	sw		$s0, 0($sp)			# store s0
	sw		$s1, 4($sp)			# store s1
	sw		$ra, 8($sp)			# store ra
	move	$s0, $0				# set sum = 0
	move	$s1, $0				# set induction variable i = 0
	move	$t1, $a0			# save argument
loop:
	bgt		$s1, $t1, done		# if i>n goto done
	move 	$a0, $s1			# set fib argument as i
	jal fibonacci				# jump and link to fibonacci
	add		$s0, $s0, $v0		# sum += fib(i)
	addi	$s1, $s1, 1			# i++
	j		loop				# jump to loop
done:
	move 	$v0, $s0			# set return value as sum
	lw		$s0, 0($sp)			# restore $s0
	lw		$s1, 4($sp)			# restore $s1
	lw		$ra, 8($sp)			# restore $ra
	addi	$sp, $sp, 12		# deallocate stack
	jr $ra						# jump to main

#------------------------- procedure fibonacci -----------------------------
# load argument n in $a0, return value in $v0. 
.text
fibonacci:	
	addi 	$sp, $sp, -12		# adiust stack for 3 items
    sw      $a0, 0($sp)         # save the argument to perform n-2
    sw      $s0, 4($sp)         # save the return value of f(n-1)
	sw 		$ra, 8($sp)			# save the return address
	slti 	$t0, $a0, 2		    # test for n < 2
	beq 	$t0, $zero, L1		# if n >= 2 go to L1
	add 	$v0, $zero, $a0		# return $a0
	addi 	$sp, $sp, 12		# pop 3 items off stack
	jr 		$ra					# return to caller
L1:		
	addi 	$a0, $a0, -1		# n >= 2, argument gets (n-1)
	jal 	fibonacci			# call fibonacci with (n-1)
    add     $s0, $v0, $0        # save the return value of f(n-1)
    addi 	$a0, $a0, -1		# argument gets (n-2)
    jal 	fibonacci			# call fibonacci with (n-2)
    add     $v0, $s0, $v0       # return value = fib(n-1) + fib(n-2)
    lw      $a0, 0($sp)         # restore the argument
    lw      $s0, 4($sp)         # restore the return value of f(n-1)
	lw 		$ra, 8($sp)			# return from jal, restore argument n
	addi 	$sp, $sp, 12		# adjust stack pointer to pop 2 items
	jr 		$ra					# return to the caller

