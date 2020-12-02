	.intel_syntax noprefix
	.data

	.text
	.global main

# Program starts here
main:
	# first argument
	mov r14, [rsi + 8]
	# second argument
    mov r15, [rsi + 16]

	# print first argument
	mov rdi, r14
	call printstr

	movzx r10, byte ptr [r15]

	# Function to parse string into integer
	str_to_int:
    	# fetch a character
		movzx rdi, byte ptr [r15]
		# skip first character if it's a negative sign
		cmp rdi, '-'
		je next_char
		# end str_to_int if the character is '\0'
    	cmp rdi, 0
    	jz ENDIF
    	# multiply the result by 10
    	imul rdx, 10
    	# convert the character to number and add it
    	sub rdi, '0'
    	add rdx, rdi
		jmp next_char
	next_char:
    	# proceed to next character
    	add r15, 1
    	jmp str_to_int
	ENDIF:
		cmp r10, '-'
		je complement
		# move result to r11
		mov r11, rdx
		jmp rot
	complement:
		mov rcx, 27
		sub rcx, rdx
		# move result to r11
		mov r11, rcx
		jmp rot
	rot:
		# fetch a character
		movzx rdi, byte ptr [r14]
		# jump to end_rot if the character is '\0'
		cmp rdi, 0
		je end_rot
		add rdi, r11
		cmp rdi, 'z'
		jg out_of_limit
		jmp next_c
	next_c:
		mov r15, rdi
    	# proceed to next character
    	add r15, 1
		add r14, 1
    	jmp rot
	out_of_limit:
		sub rdi, 26
		jmp next_c
	end_rot:
		mov rdi, r15
		call printstr

		ret

# takes a char * in rdi and prints it to the screen
# this will *overwrite* register values! nothing is safe!
printstr:
	# move the pointer in rdi to rbx so we can use
	# rdi for the first argument of putchar
	mov rbx, rdi
	jmp .printstr_check
.printstr_loop:
	# call putchar
	# "@PLT" means this function comes from somewhere else
	call putchar@PLT

	# advance the character pointer
	add rbx, 1
.printstr_check:
	# dereference the character pointer and 
	# turn it into a character.
	#
	# we need to be careful because the character is only 1
	# byte long, but the register is 8 bytes long.
	#
	# "movzx" stands for "move zero extend", and is going to
	# take one byte from the source, and replace the rest of
	# the bytes in the 8 byte register with zeros.
	#
	# if we don't fill it up with zeros, we get whatever was
	# in there before, which could be *literally anything*
	movzx rdi, byte ptr [rbx]

	# check if the character is '\0'
	cmp rdi, 0
	# if it's not equal, jump to .printstr_loop
	jne .printstr_loop

	# newline for niceness
	mov rdi, '\n'
	call putchar@PLT

	mov rax, 0
	ret
