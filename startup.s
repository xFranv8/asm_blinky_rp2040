.syntax unified
.cpu cortex-m0plus
.thumb

/* ===============================
 * Vector table
 * =============================== */
.section .vector_table
.word _stack_top
.word Reset_Handler

/* ===============================
 * Reset handler
 * =============================== */
.global Reset_Handler
.type Reset_Handler, %function

Reset_Handler:

    /* --------------------------------
     * Unreset IO_BANK0
     * -------------------------------- */
    LDR  r0, =0x4000C000      /* RESETS base */
    LDR  r1, [r0]             /* RESETS_RESET */
    MOVS r2, #0x20            /* (1 << 5) IO_BANK0 */
    BICS r1, r2               /* clear bit 5 */
    STR  r1, [r0]

wait_reset_done:
    LDR  r1, [r0, #8]         /* RESETS_RESET_DONE */
    TST  r1, r2
    BEQ  wait_reset_done

    /* --------------------------------
     * Set GPIO15 function to SIO
     * -------------------------------- */
    LDR  r0, =0x4001407C      /* GPIO15_CTRL */
    MOVS r1, #5               /* FUNCSEL = 5 (SIO) */
    STR  r1, [r0]

    /* --------------------------------
     * Enable GPIO15 output
     * -------------------------------- */
    LDR  r0, =0xD0000020      /* SIO_GPIO_OE */
    MOVS r1, #0x01
    LSLS r1, r1, #15          /* r1 = (1 << 15) */
    STR  r1, [r0]

/* ===============================
 * Blink loop
 * =============================== */
loop:
    /* Toggle GPIO15 */
    LDR  r0, =0xD000001C      /* SIO_GPIO_OUT_XOR */
    STR  r1, [r0]

    /* Delay */
    LDR  r2, =0x100000
delay:
    SUBS r2, r2, #1
    BNE  delay

    B    loop

.size Reset_Handler, . - Reset_Handler

/* ===============================
 * Stack
 * =============================== */
.section .stack
.space 0x1000                /* 4 KB stack */

.global _stack_top
_stack_top:
