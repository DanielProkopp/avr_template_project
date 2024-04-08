#include <avr/io.h>
#include <util/delay.h>

#define LED_PIN PB5
#define LED_DDR DDRB
#define LED_PORT PORTB

int main() {
  LED_DDR |= (1 << LED_PIN);

  while(1) {
    LED_PORT ^= (1 << LED_PIN);

    _delay_ms(500);
  }
  return 0;
}
