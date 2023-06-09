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
NEW_LINE equ 0x0A
;publics
public base_character_out
public character_pointer
public base_array_out
public base_clear_terminal
public base_allocate_memory
public front_layer_pointer
public back_layer_pointer
public base_allocate_output_space
public base_set_terminal_size
public base_combine_layers
public base_output_combined_layer
public base_write_character_to_all_front_layer
public base_write_character_to_all_back_layer
public return_total_size
; text to output

section ".data" writable
character_pointer: db '*'
clear_terminal_array: db   0x33,"[H",0x33,"[2J" 
clear_terminal_array_length:dq 6
front_layer_pointer: dq 0
back_layer_pointer: dq 0
combined_layer_pointer: dq 0
terminal_size: dq 0
terminal_columns_size: dq 0
terminal_rows_size: dq 0
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
base_allocate_output_space: ;allocates space for the output, *depreciated* the size of the terminal in columns goes into rdi while the size of rows goes into rsi. returns false and true through rax, false if it failed.
	
	mov r9,[terminal_size]
	call base_allocate_memory
	cmp rax,-1
	je .return_false
	mov qword [front_layer_pointer],rax
	mov rdi,r9
	call base_allocate_memory
	cmp rax,-1
	je .return_false
	mov qword [back_layer_pointer],rax
	mov rdi,r9
	call base_allocate_memory
	cmp rax,-1
	je .return_false
	mov qword [combined_layer_pointer],rax
	mov rax,1
	ret

	.return_false:
		mov rax,0
		ret


base_set_terminal_size: ;sets the window size, rdi should contain the columns. rsi should contain the rows.
	mov qword [terminal_columns_size],qword rdi
	mov qword [terminal_rows_size],qword rsi
	imul rdi,rsi
	mov qword [terminal_size],qword rdi
	ret
base_combine_layers: ;combines the two layers into the combined layer
	
	mov r9,[terminal_size]
	mov r10,[front_layer_pointer]
	mov r11,[back_layer_pointer]
	mov r12,[combined_layer_pointer]
	.combining_loop:
		mov r13,[r11]
		cmp r13,0x0
		je .place_character_from_front_layer
			
		jmp .place_character_from_back_layer

		.place_character_from_front_layer:
			mov al,byte [r10]
			mov [r12],al

			jmp .finish_loop
		.place_character_from_back_layer:
			mov al,[r11]
			mov [r12],al
			jmp .finish_loop
		.finish_loop:
			cmp r9,0
			je .end_loop
			dec r9
			inc r10
			inc r11
			inc r12
	.end_loop:
		ret
	ret
base_output_combined_layer: ;outputs the combined layer onto the terminal
	mov rdi,[combined_layer_pointer]
	mov rsi,[terminal_size]
	call base_array_out
	ret
	
base_write_character_to_all_front_layer: ;write a single character to the whole front layer, rdi should contain the character
	mov r9,qword [terminal_size]
	dec r9
	mov r10,[front_layer_pointer]

	.loop:
		
		mov [r10+r9],dil
		cmp r9,0
		je .end_loop
		dec r9
		jmp .loop


	.end_loop:
		ret



base_write_character_to_all_back_layer: ;write a single character to the whole front layer, rdi should contain the character
	mov r9,[terminal_size]
	dec r9
	mov r10,[back_layer_pointer]

	.loop:
		
		mov [r10+r9],dil
		cmp r9,0
		je .end_loop
		dec r9
		jmp .loop


	.end_loop:
		ret

return_total_size: ;temp
	mov rax,[terminal_size]
	ret
