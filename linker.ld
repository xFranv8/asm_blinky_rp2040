ENTRY(_boot2_start)

MEMORY {
  FLASH (rx) : ORIGIN = 0x10000000, LENGTH = 2M
  RAM   (rwx): ORIGIN = 0x20000000, LENGTH = 256K
}

SECTIONS {
  /* Boot2 bootloader - must be first 256 bytes */
  .boot2 : {
    KEEP(*(.boot2))
  } > FLASH

  /* Main program starts at 0x10000100 */
  .text 0x10000100 : {
    KEEP(*(.vector_table))
    *(.text*)
    *(.rodata*)
  } > FLASH

  /* Literal pools */
  .data : {
    *(.data*)
  } > RAM AT> FLASH

  /* Stack at end of RAM, grows downward */
  .stack (NOLOAD) : {
    . = ALIGN(8);
    *(.stack)
    . = ALIGN(8);
    _stack_top = .;
  } > RAM
}
