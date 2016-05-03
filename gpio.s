/******************************************************************************

USE POST-INDEXING ADDRESSING TO LOAD AND INCREMENT ADDRESS IN ONE INSTRUCTION

ldr r0, [r1], #4

Store entire picture as .word 0xNNNNNNNN, 0xMMMMMMMM, etc.
Loop ovr picture, write each word to GPSET, write inverse to GPCLR

TIME IT, add appropriate delays and sync between instructions

******************************************************************************/

.set TIMER_BASE, 0x20003000
.set GPIO_BASE,  0x20200000

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

.section .init
.globl _start
_start:

b main
.section .text

main:

	ldr r0, =GPIO_BASE
	ldr r4, =TIMER_BASE

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
	mov sp,#0x8000

	mov r0,#1024
	mov r1,#768
	mov r2,#16
	bl InitialiseFrameBuffer

	teq r0,#0
	bne noError$
		
	mov r0,#16
	mov r1,#1
	bl SetGpioFunction

	mov r0,#16
	mov r1,#0
	bl SetGpio

	error$: b error$

	noError$:

	fbInfoAddr .req r4
	mov fbInfoAddr,r0

/*
* Let our drawing method know where we are drawing to.
*/
	bl SetGraphicsAddress
	ldr r7, =0x20003000
	timereg .req r7
	time .req r5
	time2 .req r9
	gpset .req r6
	gpclr .req r10
	counter .req r8
	pointer .req r11
	offset .req r12
	
	ldr r0,=format
	mov r1,#formatEnd-format
	ldr r2,=formatEnd

	ldr hi_time, [timereg, #0x8]
	ldr lo_time, [timereg, #0x4]
	bl sleep
	ldr lo_time2, [timereg, #0x4]
	ldr hi_time2, [timereg, #0x8]
	sub lo_time, lo_time2, lo_time
	sub hi_time, hi_time2, hi_time

	push {lo_time, hi_time}
	bl FormatString
	add sp,#8
	
	mov r1,r0
	ldr r0,=formatEnd
	mov r2,#0
	mov r3,#0


	bl DrawString
loop$:
	b loop$

sleep:

	mov counter, #128000
	ldr pointer, 
	mov offset, #0
	sleep_loop:
		subs counter, #1
		bne sleep_loop
		bx lr

.section .data
format:
.ascii "%d : %d"
formatEnd:
