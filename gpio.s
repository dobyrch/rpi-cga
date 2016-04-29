.set GPIO_BASE, 0x20200000
.set GPFSEL0, 0x00
.set GPFSEL1, 0x04
.set GPFSEL2, 0x08
.set GPSET0,  0x1C
.set GPCLR0,  0x28

.set PIN_LED,       0x00000080
.set PIN_GREEN,     0x00020000
.set PIN_INTENSITY, 0x08000000
.set PIN_HSYNC,     0x00800000
.set PIN_VSYNC,     0x01000000

ldr r0, =GPIO_BASE

ldr r1, [r0, #GPFSEL0]
orr r1, #0x200000
str r1, [r0, #GPFSEL0]

ldr r1, [r0, #GPFSEL1]
orr r1, #0x200000
str r1, [r0, #GPFSEL1]

ldr r1, [r0, #GPFSEL2]
orr r1, #0x000200
orr r1, #0x001000
orr r1, #0x200000
str r1, [r0, #GPFSEL2]

mov r1, #0
orr r1, #PIN_LED
orr r1, #PIN_GREEN
orr r1, #PIN_INTENSITY
orr r1, #PIN_VSYNC
orr r1, #PIN_HSYNC
str r1, [r0, #GPSET0]

mov r1, #PIN_GREEN
str r1, [r0, #GPCLR0]

loop$:
b loop$
