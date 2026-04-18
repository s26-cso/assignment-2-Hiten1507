.section .rodata
fmtspace: .string "%d "
fmtlast: .string "%d\n"

.section .text
.globl main

main:
    addi sp, sp, -80
    sd ra, 72(sp)
    sd s0, 64(sp)
    sd s1, 56(sp)
    sd s2, 48(sp)
    sd s3, 40(sp)
    sd s4, 32(sp)
    sd s5, 24(sp)
    sd s11, 16(sp)

    mv s5, sp

    addi s0, a0, -1
    ble s0, x0, end

    mv s11, a1

    slli t0, s0, 2
    li t1, 3
    mul t0, t0, t1
    addi t0, t0, 15
    andi t0, t0, -16

    sub sp, sp, t0

    mv s1, sp
    slli t1, s0, 2
    add s2, s1, t1
    add s3, s2, t1

    li t0, 0
read_loop:
    bge t0, s0, process

    slli t1, t0, 3
    addi t1, t1, 8
    add t2, s11, t1
    ld a0, 0(t2)

    addi sp, sp, -16
    sd t0, 8(sp)
    call atoi
    ld t0, 8(sp)
    addi sp, sp, 16

    slli t1, t0, 2
    add t2, s1, t1
    sw a0, 0(t2)

    addi t0, t0, 1
    j read_loop

process:
    addi t0, s0, -1
    li s4, -1

loop:
    blt t0, x0, print

    slli t1, t0, 2
    add t1, s1, t1
    lw t3, 0(t1)

pop_loop:
    blt s4, x0, assign

    slli t1, s4, 2
    add t1, s3, t1
    lw t6, 0(t1)

    slli t1, t6, 2
    add t1, s1, t1
    lw t2, 0(t1)

    bgt t2, t3, assign

    addi s4, s4, -1
    j pop_loop

assign:
    slli t1, t0, 2
    add t2, s2, t1

    blt s4, x0, no_greater

    slli t1, s4, 2
    add t1, s3, t1
    lw t5, 0(t1)
    sw t5, 0(t2)
    j push

no_greater:
    li t5, -1
    sw t5, 0(t2)

push:
    addi s4, s4, 1
    slli t1, s4, 2
    add t1, s3, t1
    sw t0, 0(t1)

    addi t0, t0, -1
    j loop

print:
    li t0, 0

print_loop:
    bge t0, s0, end

    slli t1, t0, 2
    add t1, s2, t1
    lw a1, 0(t1)

    addi t2, s0, -1
    beq t0, t2, last

    la a0, fmtspace
    j do_print

last:
    la a0, fmtlast

do_print:
    addi sp, sp, -16
    sd t0, 8(sp)
    call printf
    ld t0, 8(sp)
    addi sp, sp, 16

    addi t0, t0, 1
    j print_loop

end:
    mv sp, s5

    ld ra, 72(sp)
    ld s0, 64(sp)
    ld s1, 56(sp)
    ld s2, 48(sp)
    ld s3, 40(sp)
    ld s4, 32(sp)
    ld s5, 24(sp)
    ld s11, 16(sp)

    addi sp, sp, 80
    ret
