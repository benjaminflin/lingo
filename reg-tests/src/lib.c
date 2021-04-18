#include <stdio.h>
int print_int(long long t)
{
    printf("%lld\n", t);
    return 0;
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