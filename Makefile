

compile_printout_c:
	@gcc -o ./compiled/printout_amd64_c.o -c printout_amd64.c
compile_printout:
	@fasm printout_amd64.asm ./compiled/printout_amd64.o
compile_test_printout: compile_printout 
	@gcc -o ./compiled/test_printout test_printout.c ./compiled/printout_amd64.o 
	
	#ld -o test_printout test_printout.o  printout_amd64.o -lc --dynamic-linker=/lib64/ld-linux-x86-64.so.2

run_test_printout:
	@echo running
	@./compiled/test_printout
crun_test_printout: compile_test_printout run_test_printout
