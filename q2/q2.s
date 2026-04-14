.section .rodata
fmt: .string "%d" #%D is a string na ,scanf,prinf ke liye 
fmtspace : .string "%d " # with a space is a string na  # spapce ke sath integers print krne k e lie 
.section .text
.globl main 
main:
li t0,0
addi sp,sp,-64
sd ra,0(sp)#return address save kia 
###########################
la a0,fmt # %d load kre ke liye
addi a1,sp,8 #n ko store krne ke lie addess dia 
call scanf
lw s0,8(sp)#s0 = sizeofarray   
####################
addi sp,sp,-4000 # arr ke liye space allocate kiya 
mv s1,sp      # s1 arr ka base add 
addi sp,sp,-4000
mv s2,sp
addi sp,sp,-4000
mv s3,sp
li s4,-1 #top = -1

loopread:
bge t0,s0,logic #i>=n
la a0,fmt # "%d"
addi a1,sp,8 #jgah bnayi temprory 
call scanf
lw t1,8(sp) # input value load
slli t2,t0,2 #4i krrhe
add t3,s1,t2 #arr[i] ka address
sw t1,0(t3) #arr[i] ki value 

addi t0,t0,1 #i++;
beq t0,t0,loopread


########################

logic:
addi t0,s0,-1 #i = n-1
loop:
blt t0,x0,print  #i<0 
blt s4,x0,emptystack# agar stack empty 
slli t1,t0,2
add t2,s1,t1
lw t3,0(t2)## arr[i] load krne ke lie 
slli t4,s4,2
add t5,s3,t4
lw t6,0(t5)
slli t7,t6,2
add t8,s1,t7
lw t9,0(t8)

blt t3,t9,smallercase  # arr[i] < arr[op]
######################
elseoop:
blt s4,x0,afterpop #empty stack
slli t1,t0,2
add t2,s1,t1
lw t3,0(t2)#arr[i]
slli t4,s4,2
add t5,s3,t4
lw t6,0(t5)#arr[stack[top]]
slli t7,t6,2
add t8,s1,t7
lw t9,0(t8)

blt t3,t9,afterpop
addi s4,s4,-1
beq t0,t0,elseoop
#############
afterpop:
slli t1,t0,2
add t2,s2,t1 #ans[i] ka addd
blt s4,x0,neg #age stack empty
#ans[i] = stack[top]
slli t3, s4, 2
add t4, s3, t3
lw t5, 0(t4)
sw t5, 0(t2)
beq t0,t0,push

neg:
li t6, -1                  # -1 assign
sw t6, 0(t2)
beq t0,t0,push
###################
emptystack:
slli t1, t0, 2
add t2, s2, t1
li t3, -1# ans[i] = -1
sw t3, 0(t2)
beq t0,t0,push




smallercase:
slli t1, t0, 2
add t2, s2, t1
slli t3, s4, 2
add t4, s3, t3
lw t5, 0(t4)
sw t5, 0(t2) #ans[i] = stak[top]
###################
push:
addi s4,s4,1
slli t1, s4, 2
add t2, s3, t1
sw t0, 0(t2) # stack[top] = i
addi t0, t0, -1# i--
beq t0,t0,loop
############
print:
li t0,0
printlop:
bge t0, s0, end# agar i >= n , stop
slli t1, t0, 2
add t2, s2, t1
lw a1, 0(t2)  # ans[i]
la a0, fmtspace
call printf # print
addi t0, t0, 1# i++
beq t0,t0, printlop
##################
end:
ld ra, 12000(sp)#add restore  
addi sp, sp, 12064
ret