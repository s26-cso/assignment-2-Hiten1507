.section .rodata
fmt: .string "%s"
yes: .string "Yes\n"
no : .string "No\n"

.section .bss # used to allocate memory withiut any value
arr : .space 10000
.section .text

.globl main
main:
addi sp,sp,-16
sd ra,0(sp)
li s0,1 # ans = 1
la a0,fmt
la a1,arr
call scanf # scanf("%s)
la a0,arr
call strlen
mv s1,a0   #s1 = x
li s2,0 #left  = 0
addi s3,s1,-1 #right = x-1
##################################
loop:
bgt s2,s3,done # l>r->exit loop



la t0,arr
add t1,t0,s2
lb t2,0(t1) #load arr[left]


add t3,t0,s3
lb t4,0(t3) # load arr[right]

bne t2,t4,not
addi s2,s2,1 # left++;
addi s3,s3,-1 # right --;
beq x0,x0,loop;
########################
not:
li s0,2
beq x0,x0,done
#############
done:
li t0 , 2
beq s0,t0,printno #ans==2 print no
la a0,yes
call printf
beq x0,x0,end
#########
printno:
la a0,no
call printf

end:
ld ra,0(sp)
addi sp,sp,16
ret