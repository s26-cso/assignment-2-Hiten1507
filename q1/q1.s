.text 
.globl make_node
.globl insert
.globl get
.globl getAtMost

make_node:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd a1, 0(sp)

    li a0, 24
    call malloc
    beq a0, x0, make_fail

    ld a1, 0(sp)
    sw a1, 0(a0)
    sd x0, 8(a0)
    sd x0, 16(a0)

    ld ra, 8(sp)
    addi sp, sp, 16
    ret

make_fail:
    li a0, 0
    ld ra, 8(sp)
    addi sp, sp, 16
    ret

insert:
    addi sp, sp, -24
    sd ra, 16(sp)
    sd a0, 8(sp)
    sd a1, 0(sp)

    beq a0, x0, ins_new

    lw t0, 0(a0)
    blt a1, t0, ins_left
    bgt a1, t0, ins_right
    j ins_done

ins_new:
    ld a1, 0(sp)
    call make_node
    j ins_exit

ins_left:
    ld t1, 8(a0)
    mv a0, t1
    ld a1, 0(sp)
    call insert

    mv t2, a0
    ld a0, 8(sp)
    sd t2, 8(a0)
    j ins_done

ins_right:
    ld t1, 16(a0)
    mv a0, t1
    ld a1, 0(sp)
    call insert

    mv t2, a0
    ld a0, 8(sp)
    sd t2, 16(a0)
    j ins_done

ins_done:
    ld a0, 8(sp)

ins_exit:
    ld ra, 16(sp)
    addi sp, sp, 24
    ret

get:
    beq a0, x0, get_null

    lw t0, 0(a0)
    beq t0, a1, get_found
    blt a1, t0, get_left

    ld a0, 16(a0)
    j get

get_left:
    ld a0, 8(a0)
    j get

get_found:
    ret

get_null:
    li a0, 0
    ret

getAtMost:
    li t2, -1

loop:
    beq a1, x0, done

    lw t0, 0(a1)

    beq t0, a0, exact
    bgt t0, a0, go_left

    mv t2, t0
    ld a1, 16(a1)
    j loop

go_left:
    ld a1, 8(a1)
    j loop

exact:
    mv a0, t0
    ret

done:
    mv a0, t2
    ret
