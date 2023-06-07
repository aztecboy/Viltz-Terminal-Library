

#include "printout_amd64.h"
#include <stdio.h>
#include <stdlib.h>
char columns_size[10];
char rows_size[10];
int main(){
	base_clear_terminal();
	int64_to_string(base_get_terminal_columns_size(),columns_size);
	int64_to_string(base_get_terminal_rows_size(),rows_size);
	printf("%s::%s\n",columns_size,rows_size);

}
