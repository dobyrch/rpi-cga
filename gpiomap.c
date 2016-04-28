#include <fcntl.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>

#define MEMLEN 0x3C

#define PIN_LED 7
#define PIN_GREEN 17
#define PIN_INTENSITY 27
#define PIN_HSYNC 23
#define PIN_VSYNC 24

#define WAIT_VSYNC 833
#define WAIT_STRIPE 8333

int main(void)
{
	int fd;
	uint32_t *gpiomem;

	fd = open("/dev/gpiomem", O_RDWR);
	if (fd == -1) {
		perror("Failed to open /dev/gpiomem");
	}


	gpiomem = mmap(NULL, MEMLEN, PROT_WRITE, MAP_SHARED, fd, 0);
	if (gpiomem == MAP_FAILED) {
		perror("Failed to mmap /dev/gpiomem");
	}

	/* set pins as outputs */
	gpiomem[0] |= 1 << 21;
	gpiomem[1] |= 1 << 21;
	gpiomem[2] |= (1 << 21) | (1 << 12) | (1 << 9);
	/* set pins to output up */
	gpiomem[7] = (1 << PIN_LED) | (1 << PIN_GREEN) | (1 << PIN_INTENSITY) | (1 << PIN_VSYNC) | (1 << PIN_HSYNC);

	while (1) {
		/* Clear green */
		gpiomem[10] = 1 << PIN_GREEN;
		usleep(WAIT_STRIPE);
		/* Set green */
		gpiomem[7] = 1 << PIN_GREEN;
		usleep(WAIT_STRIPE);

		gpiomem[10] = 1 << PIN_VSYNC;
		usleep(WAIT_VSYNC);
		gpiomem[7] = 1 << PIN_VSYNC;

	}

	return EXIT_SUCCESS;
}
