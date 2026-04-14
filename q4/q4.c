#include <stdio.h>
#include <dlfcn.h>
#include <string.h>
typedef int (*fptr)(int,int);

int main(){
    char op[10];
    int x,y;
    while(1){
    scanf("%s",op);
    if (strcmp(op, "exit") == 0) break;
    scanf("%d %d",&x,&y);

    char libname[20];
    sprintf(libname,"./lib%s.so",op);

    void* handle = dlopen(libname,RTLD_LAZY);
    if(handle==NULL){
        printf("Error\n");
        continue;
    }

    fptr func = (fptr)dlsym(handle,op);
    if(func==NULL){
        printf("Error\n");
        dlclose(handle);
        continue;
    }

    int ans  = func(x,y);
    printf("%d\n",ans);
    dlclose(handle);

}}