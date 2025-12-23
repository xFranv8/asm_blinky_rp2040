# Blinky program for Raspberry Pi Pico in ARM Assembly

This repository contains a simple "Blinky" program written in ARM assembly language for the Raspberry Pi Pico microcontroller. The program toggles an LED connected to GPIO15 on and off with a delay.

It also includes a `boot2.s` file, which is a minimal bootloader required for the Raspberry Pi Pico to initialize and run the assembly code.

## Logic

The program performs the following steps:

1. Unresets the GPIO peripheral. If you look at the datasheet, you'll see that the GPIO peripheral is held in reset by default, so we need to unreset it before we can use it. The reset control register is located at address `0x4000C000`, and the bit to unreset the GPIO peripheral is bit 5 (`IO_BANK0`).
2. Wait for the reset to be done pulling the `RESETS_RESET_DONE` register.
3. Set GPIO15 function to SIO (Software Input/Output). Looking at the datasheet, we can see that the User Bank IO registers starts at base addres of `0x40014000` (defined as `IO_BANK0_BASE`). Each GPIO has a CTRL register and a STATUS register. So, in order to access the GPIO15 we need to calculate: `0x40014000 + (15 \* 8) = 0x4001407C`. The function select for SIO is `5`.
4. Set GPIO15 as output by writing to the `GPIO_OE` SIO register located at `0xD0000000 + 0x020`. In that register, each bit corresponds to a GPIO pin, so we need to set bit 15 to `1` to configure GPIO15 as output.
5. Toggle GPIO15 on and off, using the `GPIO_OUT_XOR` SIO register located at `0xD0000000 + 0x01C`.
6. Implement a delay loop to create a visible blink effect. We use a busy-wait loop that decrements a counter until it reaches zero.

## Data Sheet References

- [Raspberry Pi Pico Datasheet](https://pip-assets.raspberrypi.com/categories/814-rp2040/documents/RP-008371-DS-1-rp2040-datasheet.pdf?disposition=inline)
