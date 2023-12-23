
	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s 
		
	AREA    main, CODE, READONLY
		
	

;Interrupt Support Code

tim2_init	PROC		;initialize Timer 2 for this program and setup its interrupt
		EXPORT	tim2_init
		ldr		r2,=(RCC_BASE+RCC_APB1ENR1)		;enable timer 2 clock
		ldr		r1,[r2]
		orr		r1,#RCC_APB1ENR1_TIM2EN
		str		r1,[r2]

		ldr		r2,=(TIM2_BASE+TIM_PSC)		;Setup the prescaler.  Assuming a 4MHz clock, this gives 1ms timer ticks
		ldr		r1,=3999
		str		r1,[r2]
		
		ldr		r2,=(TIM2_BASE+TIM_ARR)		;Setup the reload.  Assuming a 1ms tick, this gives 1s overflows
		ldr		r1,=999
		str		r1,[r2]
		
		ldr		r2,=(TIM2_BASE+TIM_CR1)		;enable the counter in control register 1
		ldr		r1,[r2]
		orr		r1,#TIM_CR1_CEN
		str		r1,[r2]
		
		ldr		r2,=(TIM2_BASE+TIM_DIER)		;enable the timer update interrupt
		ldr		r1,[r2]
		orr		r1,#TIM_DIER_UIE
		str		r1,[r2]
		
		ldr		r2,=(NVIC_BASE+NVIC_ISER0)	;enable the TIM2 interrupt in NVIC_ISER0
		ldr		r1,=(1<<28)
		str		r1,[r2]
		bx		lr	
		
		ENDP
		ALIGN	
			
		END
	