#include <stdlib.h>
#include <stdio.h>

void *new_array(size_t elements, size_t size)
{
	return malloc(elements * size);
}

int main()
{
	long *array = (long *)new_array(10, sizeof(long));
	array[0] = 3;
	array[9] = 12;

	free(array);
	return 0;
}
