#include <fcntl.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>

int main(void)
{
	int fd;
	uint32_t *gpiomem;

	fd = open("/dev/gpiomem", O_RDWR);
	if (fd == -1) {
		fprintf(stderr, "Failed to open /dev/gpiomem\n");
	}

	gpiomem = mmap(NULL, 0x3C, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	if (gpiomem == MAP_FAILED) {
		fprintf(stderr, "Failed to mmap /dev/gpiomem\n");
	}

	/* set pin 7 as an output */
	gpiomem[0] = 1 << 21;
	/* set pin 7 to output up */
	gpiomem[7] = 1 << 7;

	sleep(5);
	msync(gpiomem, 0x3C, MS_SYNC);
	printf("Called msync\n");
	sleep(5);

	return EXIT_SUCCESS;
}
