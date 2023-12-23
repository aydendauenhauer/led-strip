	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s 
		
	AREA    main, CODE, READONLY
	EXPORT	__main
	ENTRY
__main PROC

		ldr r0, =0x00000000
		bl spi32
		ldr r0, =0xE10000FF
		bl spi32
		ldr r0, =0x00000000
		bl spi32	
endless	b endless
		ENDP

;Utility routines for the 60-LED SK9822 LED strip
spisw_init	PROC		;Initialize Port E pins 13/15 as a outputs to use as a software SPI port.
						;Try push-pull outputs at 3.3V
						;Pin 13 is sclk, pin 15 is Dout
						;Data is clocked into the RGB strip on the rising edge of sclk
			EXPORT	spisw_init
		;Enables the GPIO port clock using the RCC_AHB2ENR register
		LDR r0, =(RCC_BASE + RCC_AHB2ENR)
		LDR r1, [r0]
		ORR r1, #RCC_AHB2ENR_GPIOEEN
		STR r1, [r0]
		
		;Set the pin mode to digital output using the GPOIE_MODER register
		LDR r0, =(GPIOE_BASE+GPIO_MODER)
		LDR r1, [r0]
		BIC r1, r1, #0x0000A000
		ORR r1, r1, #(1<<(2*13))
		ORR r1, r1, #(1<<(2*15))
		STR r1, [r0]
		
		bx		lr
		ENDP
			
spi32		PROC	;send 32 bits out the SPI port - MSB first
					;send out the 32 bits of r0
					;sclk starts low and ends low
			EXPORT	spi32
		mov		r1,#32
		ldr		r2,=(GPIOE_BASE+GPIO_BSRR)
		push	{r4,r5,r6}
		ldr		r3,=GPIO_BSRR_BS_13
		ldr		r4,=GPIO_BSRR_BR_13
		ldr		r5,=GPIO_BSRR_BS_15
		ldr		r6,=GPIO_BSRR_BR_15			
spi32_1	tst		r0,#0x80000000
		streq	r6,[r2]
		strne	r5,[r2]
		str		r3,[r2]
		str		r4,[r2]
		lsl		r0,#1
		subs	r1,#1
		bne		spi32_1
		pop		{r4,r5,r6}
		bx		lr
		ENDP				

		ALIGN	
			
		END