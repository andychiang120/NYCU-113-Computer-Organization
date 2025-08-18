.data
	input_msg1:	    .asciiz "Enter the number: "
	input_msg2:	    .asciiz "Enter the modulo: "
    output_msg1:    .asciiz "Inverse not exist.\n"
    output_msg2:    .asciiz "Result: "
	newline: 	    .asciiz "\n"

.text
.globl main
#------------------------- main -----------------------------
main:
# print input_msg1 on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, input_msg1		# load address of string into $a0
	syscall                 	# run the syscall
 
# read the input integer in $v0
	li      $v0, 5          	# call system call: read integer
	syscall                 	# run the syscall
	move    $t0, $v0      		# store input in $t0 

# print input_msg2 on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, input_msg2		# load address of string into $a0
	syscall                 	# run the syscall
 
# read the input integer in $v1
	li      $v0, 5          	# call system call: read integer
	syscall                 	# run the syscall
    move    $a0, $t0            # store input in $a0 (set arugument of procedure mod_inverse)
	move    $a1, $v0      		# store input in $a1 (set arugument of procedure mod_inverse)

# jump to procedure mod_inverse
	jal 	mod_inverse
	move 	$t0, $v0			# save return value in t0 (because v0 will be used by system call) 

# test if gcd(a, b) equal 1
    beq     $t0, -1, not_exist

# print output_msg2 on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, output_msg2	# load address of string into $a0
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

not_exist:
# print output_msg1 on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, output_msg1	# load address of string into $a0
	syscall    

# print a newline at the end
	li		$v0, 4				# call system call: print string
	la		$a0, newline		# load address of string into $a0
	syscall						# run the syscall

# exit the program
	li 		$v0, 10				# call system call: exit
	syscall						# run the syscall

#------------------------- procedure mod_inverse -----------------------------
# load argument n in $a0, return value in $v0. 
.text
mod_inverse:
    addi    $sp, $sp, -16        
    sw      $s0, 0($sp)         # store s0 for s0 (in C code)
    sw      $s1, 4($sp)         # store s1 for s1 (in C code)
    sw      $s2, 8($sp)         # store s2 for r0 (in C code)
    sw      $s3, 12($sp)        # store s3 for r1 (in C code)
    move    $s2, $a0
    move    $s3, $a1
    li      $s0, 1
    li      $s1, 0
loop:
    beq      $s3, $0, L
    div		$s2, $s3			# $s2 / $s3
    mflo	$t0					# $t0 = $s2 / $s3, $t0 is q
    mfhi	$t1					# $t1 = $s2 % $s3, $t1 is t 
    move    $s2, $s3
    move    $s3, $t1
    mul     $t2, $t0, $s1
    sub     $t1, $s0, $t2
    move    $s0, $s1
    move    $s1, $t1
    j       loop
L:
    bne     $s2, 1, no_mod_inverse
    bgez    $s0, done 
    add     $v0, $s0, $a1
    lw      $s0, 0($sp)         # restore s0 for s0 (in C code)
    lw      $s1, 4($sp)         # restore s1 for s1 (in C code)
    lw      $s2, 8($sp)         # restore s2 for r0 (in C code)
    lw      $s3, 12($sp)        # restore s3 for r1 (in C code)
    addi    $sp, $sp, 16        
    jr      $ra
no_mod_inverse:
    lw      $s0, 0($sp)         # restore s0 for s0 (in C code)
    lw      $s1, 4($sp)         # restore s1 for s1 (in C code)
    lw      $s2, 8($sp)         # restore s2 for r0 (in C code)
    lw      $s3, 12($sp)        # restore s3 for r1 (in C code)
    addi    $sp, $sp, 16        
    li      $v0, -1
    jr      $ra
done:
    move    $v0, $s0
    lw      $s0, 0($sp)         # restore s0 for s0 (in C code)
    lw      $s1, 4($sp)         # restore s1 for s1 (in C code)
    lw      $s2, 8($sp)         # restore s2 for r0 (in C code)
    lw      $s3, 12($sp)        # restore s3 for r1 (in C code)
    addi    $sp, $sp, 16        
    jr      $ra
