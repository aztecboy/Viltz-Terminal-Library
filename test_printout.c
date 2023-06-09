

#include "printout_amd64.h"
#include <stdio.h>
#include <stdlib.h>
char columns_size[10];
char rows_size[10];
char test_array[]={'\0','\0','\0'};
int main(){
	base_clear_terminal();
	
	int64_to_string(base_get_terminal_columns_size(),columns_size);
	int64_to_string(base_get_terminal_rows_size(),rows_size);
	//printf(">>%b\n",base_init_frame());
	base_init_frame();
	base_combine_layers();
	base_write_character_to_all_back_layer('\0');
	base_write_character_to_all_front_layer('!');
	base_combine_layers();
	base_output_combined_layer();
	printf("> %d\n",return_total_size());
	
	return 0;

}
