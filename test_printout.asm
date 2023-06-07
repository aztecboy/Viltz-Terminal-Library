

format ELF64
extrn base_character_out
extrn base_array_out
extrn base_get_terminal_columns_size
extrn base_64bit_int_to_string
public _start
section ".data" writable
text: db 0,0,0,0,0,0,0,0,0,0,0,0x0A
text_size: dq 12
is_running:db "is running",0x0A
is_running_size:dq 11
is_done:db "is done",0x0a
is_done_size:dq 8
section ".text" executable
	_start:
		lea rdi,[is_running]
		mov rsi,qword [is_running_size]
		call base_array_out
		call base_get_terminal_columns_size
		
		
		mov rdi,20
		mov rsi,[text_size]
		lea rdx,[text]
		call base_64bit_int_to_string
		mov r9,0
		
		mov rdi,"!"
		call base_character_out
		mov rdx,text
		mov r10,[text_size]
		.print_loop:
			cmp r9, r10
			jge .end
			mov rdi, [rdx]
			call base_character_out
			inc rdx
			inc r9
			mov rdi, "!"
			call base_character_out
			jmp .print_loop
		.end:
		mov rdi,"&"
		call base_character_out
		;lea rdi,[text]
		;mov rsi,[text_size]
		;call base_array_out
		
		
		
		;lea rsi,[is_done]
		;mov rdi,qword [is_done_size]
		;call base_array_out
		mov edi,0
		mov rax,60
		syscall
		
