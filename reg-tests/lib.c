#include <stdio.h>
#include <stdlib.h>
typedef struct adt {
    long long tag;
    char *data;
} ADT;
ADT unit = (ADT) { .tag = 0, .data = NULL }; 
long long print_int(long long t)
{
    printf("%lld\n", t);
    return 0;
}
ADT print_string(ADT adt)
{
    printf("%s\n", adt.data);
    return adt;
}
ADT prim_alloc(long long size) {
    char *p = malloc((size_t) size);
    return (ADT) { .tag = 0, .data = p }; 
}
ADT prim_drop(ADT d) {
    free(d.data);
    return unit; 
}
ADT set_bit(ADT adt, long long i, char c) {
    adt.data[i] = c;
    return adt;
}
char *believe_me(char *x) {
    return x;
}



int __prim__binop__and(int a, int b) { return a && b; }
int __prim__binop__or(int a, int b) { return a || b; }
long long __prim__binop__plus(int a, int b) { return a + b; }
long long __prim__binop__minus(int a, int b) { return a - b; }
long long __prim__binop__times(int a, int b) { return a * b; }
long long __prim__binop__divide(int a, int b) { return a / b; }
int __prim__binop__geq(long long a, long long b) { return a >= b; }
int __prim__binop__gt(long long a, long long b) { return a > b; }
int __prim__binop__leq(long long a, long long b) { return a <= b; }
int __prim__binop__lt(long long a, long long b) { return a < b; }
int __prim__binop__eq(long long a, long long b) { return a == b; }
int __prim__binop__neq(long long a, long long b) { return a != b; }
int __prim__unop__not(int a) { return !a; }
long long __prim__unop__neg(long long a) { return -a; }