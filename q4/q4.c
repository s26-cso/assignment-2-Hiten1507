#include <stdio.h>
#include <dlfcn.h>

int main() {
    char op[6];
    int a, b;

    while (1) {
        int ret = scanf("%5s %d %d", op, &a, &b);
        if (ret == EOF) {
            break;
        }
        if (ret != 3) {
            continue;
        }

        char libname[20];
        sprintf(libname, "./lib%s.so", op);

        void *handle = dlopen(libname, RTLD_LAZY);
        if (!handle) {
            printf("Error\n");
            continue;
        }

        int (*func)(int, int);
        func = (int (*)(int,int)) dlsym(handle, op);

        if (!func) {
            dlclose(handle);
            printf("Error\n");
            continue;
        }

        int result = func(a, b);
        printf("%d\n", result);

        dlclose(handle);
    }

    return 0;
}
