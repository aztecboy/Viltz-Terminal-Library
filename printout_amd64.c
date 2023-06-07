//C
//work of valvecore

//includes

#include <sys/ioctl.h>
#include <unistd.h>
#include <stdbool.h>
#include "printout_amd64_external.h"
#include "stdio.h"
//constant/global variables and structs

struct winsize size;


unsigned long long base_get_terminal_columns_size() { //gets the size of the terminal in columns, 
	
	ioctl(STDOUT_FILENO, TIOCGWINSZ, &size);
	return size.ws_col;
}
unsigned long long base_get_terminal_rows_size(){ //gets the size of the terminal in rows
	ioctl(STDOUT_FILENO, TIOCGWINSZ, &size);
	return size.ws_row;
}

void int64_to_string(unsigned long long number, char* str) { //turns a 64bit integer into a string
    if (number == 0) {
        str[0] = '0';
        str[1] = '\0';
        return;
    }

    int isNegative = 0;
    if (number < 0) {
        isNegative = 1;
        number = -number;
    }

    int i = 0;
    while (number > 0) {
        str[i++] = (char)('0' + (number % 10));
        number /= 10;
    }

    if (isNegative)
        str[i++] = '-';

    str[i] = '\0';

    // Reverse the string
    int length = i;
    for (int j = 0; j < length / 2; j++) {
        char temp = str[j];
        str[j] = str[length - j - 1];
        str[length - j - 1] = temp;
    }
}

