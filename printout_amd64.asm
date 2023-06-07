;fasm assembly
;work of valve-core

format ELF64

;external functions

;Constant definitions
STD_IN equ 0
STD_OUT equ 1
SYS_WRITE equ 1
SYS_READ equ 0
SYS_BRK equ 12
;publics
public base_character_out
public character_pointer
public base_array_out
public base_clear_terminal
public base_allocate_memory
public front_layer_pointer
public back_layer_pointer
public base_allocate_output_space
; text to output

section ".data" writable
character_pointer: db ''
clear_terminal_array: db   27,"[H",27,"[2J" 
clear_terminal_array_length:dq 4
front_layer_pointer: dq 0
back_layer_pointer: dq 0
section ".text" executable

; prints a single character out to the terminal, uses c calling convention. rdi should contain the character
base_character_out:
	mov [character_pointer],dil
	mov rdx,1
	mov rsi,character_pointer
	mov rdi,STD_OUT
	mov rax,SYS_WRITE
	syscall
	ret

base_array_out: ; prints out a character array, rsi is the length of the array. rdi is the pointer
	
	mov rdx,rsi
	mov rsi,rdi
	mov rdi,STD_OUT
	mov rax,SYS_WRITE
	syscall
	ret

base_clear_terminal: ;clears the terminal
	lea rdi,[clear_terminal_array]
	mov rsi,clear_terminal_array_length
	call base_array_out
	ret
base_allocate_memory: ;the bytes to allocate goes into rdi, returns a pointer in rax. 
	mov rax,SYS_BRK
	mov rsi,rdi
	mov rdi,0
	syscall
	ret
base_allocate_output_space: ;allocates space for the output, the size of the terminal in columns goes into rdi while the size of rows goes into rsi. returns false and true through rax, false if it failed.
	imul rdi,rsi
	mov r9,rdi
	call base_allocate_memory
	cmp rax,-1
	je .return_false
	mov [front_layer_pointer], rax
	mov rdi,r9
	call base_allocate_memory
	cmp rax,-1
	je .return_false
	mov [back_layer_pointer], rax
	mov rax,1
	ret

	.return_false:
		mov rdi,"!"
		call base_character_out
		mov rax,0
		ret

	
