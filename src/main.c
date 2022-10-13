#include <stdint.h>
#include "peripherals.h"

RCC_t   * const RCC     = (RCC_t *)     0x40023800;
GPIOx_t * const GPIOA   = (GPIOx_t *)   0x40020000;
TIMx_t  * const TIM2    = (TIMx_t *)    0x40000000;

volatile uint32_t var = 1;

int main(void){

    // Enable GPIOA
    RCC->RCC_AHB1ENR |= 1;

    // Configure PA5 alternate function
    GPIOA->GPIOx_MODER &= ~(3 << (5 * 2));
    GPIOA->GPIOx_MODER |=  (2 << (5 * 2));

    // Set PA5 AF01
    GPIOA->GPIOx_AFRL &= ~(0xF << (5 * 4));
    GPIOA->GPIOx_AFRL |=  (1 << (5 * 4));
    
    /********************/
    /** Configure TIM2 **/
    /********************/
    // Enable TIM2
    RCC->RCC_APB1ENR |= 1; 
    // Set Prescaler to 16000
    TIM2->TIMx_PSC = 16000 - 1;
    // Set Auto Reload Value to 1000
    TIM2->TIMx_ARR = 1000 - 1;
    // Set Compage Value to 0
    TIM2->TIMx_CCR1 = 0;
    // Set Toggle Function upon Compare match 
    TIM2->TIMx_CCMR1 &= ~(7 << 4);
    TIM2->TIMx_CCMR1 |=  (3 << 4);
    // Enable Compare Mode
    TIM2->TIMx_CCER |= 1;
    // Reset Current Value Register
    TIM2->TIMx_CNT = 0;
    // Start Counter
    TIM2->TIMx_CR1 |= 1;

    for(;;){

    }
}
