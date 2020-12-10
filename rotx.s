	.intel_syntax noprefix
	.data

	.text
	.global main

# Program starts here
main:
	mov r14, [rsi + 8]
   	mov r15, [rsi + 16]
	movzx r10, byte ptr [r15]
	mov r8, 0
str_to_int:
	movzx rdi, byte ptr [r15]
	cmp rdi, '-'
	je next_char
	cmp rdi, 0
	jz ENDIF
	# multiply the result by 10
	imul r8, 10
	sub rdi, '0'
	add r8, rdi
	jmp next_char
next_char:
	add r15, 1
	jmp str_to_int
ENDIF:
	cmp r10, '-'
	je complement
	mov r12, r8
	jmp rot
complement:
	mov rcx, 26
	sub rcx, r8
	mov r12, rcx
	jmp rot
rot:
	movzx rdi, byte ptr [r14]
	cmp rdi, 0
	je end_rot
	add rdi, r12
	cmp rdi, 'z'
	jg out_of_limit
	jmp next_c
next_c:
	call putchar@PLT
	add r14, 1
	jmp rot
out_of_limit:
	sub rdi, 26
	jmp next_c
end_rot:
	mov rdi, '\n'
	call putchar@PLT
	ret

