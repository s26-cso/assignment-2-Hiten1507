#0 - > data 8-> left , 16 -> right 
#  root -> x10,n -> x11,temp-> x5,x6    


newnode:
li a0,24
call malloc
mv x10,a0
sd x11,0(x10) # node->data = n
sd x0,8(x10) #node->left = NULL;
sd x0,16(x10) #node->right = NULL;
jalr x0,0(x1) #
###########################

insert:

addi sp,sp,-24 #space bnali
sd x1,16(sp) # save return add
sd x10,8(sp) # save root
sd x11,0(sp) # save n
beq x10,x0,l1 # root==NULL
ld x5,0(x10) # root->data
blt x11,x5,left # if(n<root->data)
bgt x11,x5,right # if(n>root->data)
beq x0,x0,l2



l1:
ld x11,0(sp)
mv x10,x0
jal x1,newnode
beq x0,x0,exit

left:
ld x6,8(x10)
mv x10,x6
ld x11,0(sp)
jal x1,insert

ld x6,8(sp)
sd x10,8(x6)
beq x0,x0,l2


right:
ld x6,16(x10)
mv x10,x6
ld x11,0(sp)
jal x1,insert   

ld x6,8(sp)
sd x10,16(x6)
beq x0,x0,l2

l2:
ld x10,8(sp)

exit:
ld x1, 16(sp)      # return address restore
addi sp, sp, 24   # stack free
jalr x0, 0(x1)    # return
######################################
search:
addi sp,sp,-16
sd x1,8(sp)
sd x11,0(sp)

beq x10,x0,NULL # root==NULL
ld x5 , 0(x10) # x5 = root->data
beq x5,x11,found # root->data==n->return current node
blt x11,x5,goleft # n<root->data -> left me jao 
bgt x11,x5,goright #whi right me jao 

goleft:
ld x10,8(x10) #x10 = root->left
ld x11,0(sp)
jal x1,search
beq x0,x0,retsearch

goright:
ld x10,16(x10)
ld x11,0(sp)
jal x1,search
beq x0,x0,retsearch

found:
beq x0,x0,retsearch

NULL:
li x10,0 #x10 = NULL

retsearch:
ld x1,8(sp)
addi sp,sp,16
jalr x0,0(x1)
# return NULL;
##########################
max:
addi sp,sp,-24
sd x1,16(sp)# ret add
sd x10,8(sp) #root pointr
sd x11,0(sp) # val

beq x10,x0,NULLCASE # return krna hai -1 not 0 

ld x5,0(x10) #x5 = root->data

bgt x5,x11,leftjao

# candidate = root->val
ld x6,16(x10)# root->right
mv x10,x6
ld x11,0(sp)
jal x1,max

mv x6,x10 #x6 = ans from right
li x5,-1
beq x6,x5,uroot
mv x10,x6
beq x0,x0,exitmax

uroot:
ld x10,8(sp)
ld x10,0(x10) #root->data
beq x0,x0,exitmax

leftjao:
ld x10,8(x10)
ld x11,0(sp)
jal x1,max #rec call: max(left,n)
beq x0,x0,exitmax

NULLCASE:
li x10,-1

exitmax:
ld x1,16(sp)
addi sp,sp,24
jalr x0,0(x1)