//externs
extern void base_array_out(char*,unsigned long long);
extern void base_character_out(char);
extern void base_clear_terminal();
extern void base_allocate_memory(unsigned long long);
extern bool base_allocate_output_space();
extern void base_set_terminal_size(unsigned long long,unsigned long long);
extern void base_output_combined_layer();
extern void base_combine_layers();
extern void base_write_character_to_all_front_layer(char);
extern void base_write_character_to_all_back_layer(char);
extern void testy();
extern unsigned long long total_terminal_size; //temp
extern unsigned long long return_total_size(); //temp
extern char* back_layer_pointer;
extern char* front_layer_pointer;
extern char* combined_layer_pointer;



