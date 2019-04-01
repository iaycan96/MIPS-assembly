		.data                    # Data memory area.
	#Series:::::	
		myseries:		.space 100
		menu:			.asciiz "\nWelcome to our MIPS project!\nMain Menu:\n1.Prim's Algorithm\n2.Number Series\n3.Encrypt/Decrypt\n4.Exit\nPlease select an option:\n"
		prmpt1:     	.asciiz "\nEnter the first number in the series: "
		prmpt2:     	.asciiz "\nEnter the number of integers in the series: "
		sumtext:    	.asciiz "\nEnter the offset between two successive integers in the series:  "
		exitprmpt:		.asciiz "\nProgram ends. BYE :)"
		summation:		.asciiz "\nThe summation of the number is:"
		space:			.asciiz " "

	#encrypt,decrypt
		inputstring:	.space 100
		SOURCE:			.space 100
		cryptprmpt1:	.asciiz "\nEnter an input string:"
		cryptprmpt2:	.asciiz "\nEnter an offset value:"
		cryptprmpt3:	.asciiz "\nSOURCE:"
		cryptprmpt4:	.asciiz "\nPROCESSED:"


		.text           	# Code area starts here
main:	li	$v0,	4
		la $a0,menu
		syscall
		li $v0 , 5
		syscall
		addi $t0,$zero,1
		beq $t0,$v0, prim
		addi $t0,$t0,1
		beq $t0,$v0,numberSeries
		addi $t0,$t0,1
		beq $t0,$v0,crypt
		addi $t0,$t0,1
		beq $t0,$v0 exit
	

numberSeries:
			li   $v0, 4    	   # Syscall to print prompt string
			la   $a0, prmpt1         # li and la are pseudo instr.
			syscall
			li	$v0, 5		# read number into $v0
			syscall			# make the syscall read_int
			move	$t0, $v0	# move the number read into $t0	(ilk sayi)
			
			
			li   $v0, 4    	   # Syscall to print prompt string
			la   $a0, prmpt2         # li and la are pseudo instr.
			syscall
			li	$v0, 5		# read number into $v0
			syscall			# make the syscall read_int
			move	$t1, $v0	# move the number read into $t1	(toplam sayi)
			
			
			li   $v0, 4    	   # Syscall to print prompt string
			la   $a0, sumtext         # li and la are pseudo instr.
			syscall
			li	$v0, 5		# read number into $v0
			syscall			# make the syscall read_int
			move	$t2, $v0	# move the number read into $t2	(artis miktari)

			add $s0, $zero, $zero    # sum of numbers
			add $t3, $zero, $zero    # i
			
			add $t6 ,$zero,$zero	#index of array
						
			
	while:	beq $t3,$t1 endwhile	#if(i==numberofnumbers)
			mul $t4, $t3,$t2		#i times offset
			add $t5,$t4,$t0			#element of series
			add $s0,$s0,$t5			#new element added to the sum
			sw $t5,myseries($t6)	#new element inserted to the list
			addi $t6,$t6,4			#next index of the element
			addi $t3,$t3,1			#i =i+1
			j while					


	endwhile: 
	
	addi 	$t3,$zero,0				# i==0
	while2:	beq $t3,$t1 endwhile2	# compare i and n
			sll $t6,$t3,2			#index of array
			
			lw $t5,myseries($t6)	#load the element of array 
			li $v0 ,1				
			addi $a0,$t5,0			#system call to print element of array
			syscall
			addi $t3,$t3,1
			li   $v0, 4    	   # Syscall to print prompt string
			la   $a0, space         # li and la are pseudo instr.
			syscall
			
			
			j while2	
	
	endwhile2:

	
			li   $v0, 4	            # syscal to print string
            la   $a0, summation		
            syscall
			move $a0, $s0             # Syscall to print an summation
            li   $v0, 1
            syscall
			
						
			
			
	
			j main









prim:
j main










crypt:
			
			li   $v0, 4    	   				# Syscall to print prompt string
			la   $a0, cryptprmpt1         	# li and la are pseudo instr.
			syscall
			li	$v0,8						#Getting input from user
			la	$a0,inputstring
			li	$a1,100
			syscall
			la $t0,($a0) 					# Entered string is stored in the t0 register
			li $t1,100 						# string length
			
	takeoffset:		
			li   $v0, 4    	   				# Syscall to print prompt string
			la   $a0, cryptprmpt2         	# li and la are pseudo instr.
			syscall
			li	$v0, 5						# read number into $v0
			syscall							# make the syscall read_int
			move	$t2, $v0				# move the number read into $t2	(offset)
			bgt		$t2, 25	,takeoffset
			blt		$t2,-25	,takeoffset	
			beq		$t2,0,	,takeoffset
			
			#loop will start here:
			la $t7,SOURCE						#t7 holds the addres of Source
			addi 	$t4,$zero,0					#t4=i=0
	loop1:	beq		$t4,100	endloop1		
			lb 		$t3, 0($t0)					#reading first character
			
			beq 	$t3,10,endcrypt				# if character is NULL
			bgt 	$t3,122,NotLover			#if character is greater than Z
			blt 	$t3,97,NotLover				#if character is lover than A		
			addi 	$t3,$t3,-32					#makes all characters upper
NotLover:	sb		$t3,SOURCE($t4)			
			bgt		$t3,90,Notletter
			blt		$t3,65,Notletter
			add		$t3,$t3,$t2
	contpoint:
			bgt		$t3,90 greaterThanZ
			blt  	$t3,65,lessThanA
Notletter:				
			
			
			sb		$t3,inputstring($t4)			

			addi $t4,$t4,1
			addi 	$t0,$t0,1
			j loop1

endloop1:

			
			

endcrypt:	

			li   $v0, 4    	   				# Syscall to print prompt string
			la   $a0, cryptprmpt3         	# li and la are pseudo instr.
			syscall
			addi $t4,$zero,0
			la $t0,SOURCE
	loop3:	beq $t4,100,endloop3
			li,$v0, 11                  	# service 11 is print character
			lb  $a0, 0($t0)
			beq $a0,10,endloop3				# if character is NULL
			syscall
			addi $t0,$t0,1
			j loop3
	
	endloop3:


			li   $v0, 4    	   				# Syscall to print prompt string
			la   $a0, cryptprmpt4         	# li and la are pseudo instr.
			syscall
			addi $t4,$zero,0
			la $t0,inputstring
	loop2:	beq $t4,100,endloop2
			li,$v0, 11                  	# service 11 is print character
			lb  $a0, 0($t0)
			beq $a0,10,endloop2				# if character is NULL
			syscall
			addi $t0,$t0,1
			j loop2
	endloop2:


			addi $t1,$zero,10
			addi $t0,$zero,0
			add $t2,$zero,100
		
	clearloop:
				sb $t1,SOURCE($t0)
				sb $t1,inputstring($t0)
				addi $t0,$t0,1
				
				bne $t0,$t2 clearloop 


j main

greaterThanZ:
	addi $t3,$t3,-26
	j contpoint
lessThanA:
	addi $t3,$t3,26
	j contpoint



exit:	li	$v0,	4
		la $a0,exitprmpt
		syscall