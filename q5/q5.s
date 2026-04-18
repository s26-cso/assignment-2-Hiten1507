.section .rodata
filename: .string "input.txt"
yes:      .string "Yes\n"
no:       .string "No\n"

.section .text
.globl main

main:
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)
    sd s1, 40(sp)
    sd s2, 32(sp)
    sd s3, 24(sp)

    # 1. Open file
    la a0, filename
    li a1, 0
    call open
    mv s0, a0

    li t0, -1
    beq s0, t0, printno

    # 2. get file size
    mv a0, s0
    li a1, 0
    li a2, 2
    call lseek
    mv s1, a0

    # 3. pointers
    li s2, 0
    addi s3, s1, -1

loop:
    bge s2, s3, printyes

    # read left
    mv a0, s0
    mv a1, s2
    li a2, 0
    call lseek

    mv a0, s0
    addi a1, sp, 8
    li a2, 1
    call read
    lbu t2, 8(sp)

    # read right
    mv a0, s0
    mv a1, s3
    li a2, 0
    call lseek

    mv a0, s0
    addi a1, sp, 8
    li a2, 1
    call read
    lbu t4, 8(sp)

    bne t2, t4, printno

    addi s2, s2, 1
    addi s3, s3, -1
    j loop

printyes:
    la a0, yes
    call printf
    j end

printno:
    la a0, no
    call printf

end:
    li t0, -1
    beq s0, t0, skip_close
    mv a0, s0
    call close

skip_close:
    ld ra, 56(sp)
    ld s0, 48(sp)
    ld s1, 40(sp)
    ld s2, 32(sp)
    ld s3, 24(sp)
    addi sp, sp, 64
    li a0, 0
    ret
