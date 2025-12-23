TARGET = blink
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy
UF2CONV = elf2uf2-rs

all: $(TARGET).uf2

$(TARGET).elf: boot2.s startup.s linker.ld
	$(AS) -mcpu=cortex-m0plus -mthumb -g boot2.s -o boot2.o
	$(AS) -mcpu=cortex-m0plus -mthumb -g startup.s -o startup.o
	$(LD) -T linker.ld boot2.o startup.o -o $@

$(TARGET).uf2: $(TARGET).elf
	$(UF2CONV) $< $@

clean:
	rm -f *.o *.elf *.bin *.uf2

flash: all
	cp $(TARGET).uf2 /Volumes/RPI-RP2/
