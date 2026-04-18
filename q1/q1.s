.globl make_node
.globl insert
.globl get
.globl getAtMost

make_node:
    addi sp, sp, -16
    sd x1, 8(sp)
    sd x11, 0(sp)

    li a0, 24
    call malloc

    ld x11, 0(sp)
    sw x11, 0(a0)
    sd x0, 8(a0)
    sd x0, 16(a0)

    mv x10, a0
    ld x1, 8(sp)
    addi sp, sp, 16
    ret

insert:
    addi sp, sp, -24
    sd x1, 16(sp)
    sd x10, 8(sp)
    sd x11, 0(sp)

    beq x10, x0, ins_new

    lw x5, 0(x10)
    blt x11, x5, ins_left
    bgt x11, x5, ins_right
    j ins_done

ins_new:
    ld x11, 0(sp)
    mv x10, x11
    call make_node
    j ins_exit

ins_left:
    ld x10, 8(x10)
    ld x11, 0(sp)
    call insert
    mv x6, x10
    ld x10, 8(sp)
    sd x6, 8(x10)
    j ins_done

ins_right:
    ld x10, 16(x10)
    ld x11, 0(sp)
    call insert
    mv x6, x10
    ld x10, 8(sp)
    sd x6, 16(x10)
    j ins_done

ins_done:
    ld x10, 8(sp)

ins_exit:
    ld x1, 16(sp)
    addi sp, sp, 24
    ret

get:
    beq x10, x0, get_null

    lw x5, 0(x10)
    beq x5, x11, get_found
    blt x11, x5, get_left

    ld x10, 16(x10)
    j get

get_left:
    ld x10, 8(x10)
    j get

get_found:
    ret

get_null:
    li x10, 0
    ret

getAtMost:
    li x7, -1

loop:
    beq x11, x0, done

    lw x5, 0(x11)

    beq x5, x10, exact
    bgt x5, x10, go_left

    mv x7, x5
    ld x11, 16(x11)
    j loop

go_left:
    ld x11, 8(x11)
    j loop

exact:
    mv x10, x5
    ret

done:
    mv x10, x7
    ret
