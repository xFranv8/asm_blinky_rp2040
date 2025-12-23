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
    LDR r0, =0x4000C000
    LDR r1, [r0]
    MOVS r2, #0x20
    BICS r1, r2
    STR r1, [r0]

wait_reset_done:
    LDR r3, =0x4000c008
    LDR r4, [r3]
    TST r4, r2
    BEQ wait_reset_done

Funcsel:
    LDR r3, =0x400140A4
    MOVS r4, #5
    STR r4, [r3]

enable_output:
    LDR r3, =0xD0000020
    MOVS r1, #0x01
    LSLS r1, r1, #20
    STR r1, [r3]

loop:
    LDR r3, =0xD000001C
    STR r1, [r3]

    LDR r2, =0x100000

delay:
    SUBS r2, r2, #1
    BNE delay

    B loop

.size Reset_Handler, . - Reset_Handler

/* ===============================
 * Stack
 * =============================== */
.section .stack
.space 0x1000                /* 4 KB stack */

.global _stack_top
_stack_top:
