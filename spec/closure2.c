// let foo x = let z = x + 5 in fun y -> y + z
// let x = e1 in e2 -> (fun x -> e2) e1
// let foo x = (fun z -> fun y -> y + z) (x + 5)
// let foo x = (fun env, y -> y + env.z))
#include <stdio.h>
#include <stdlib.h>

struct Env;
struct Closure;
union FuncRet;

union FuncRet foo(void *, void *);
union FuncRet fun_y(void *, void *);

struct Closure
{
    void *env;
    union FuncRet (*code_ptr)(void *, void *);
};

union FuncRet
{
    int _val;
    struct Closure _clos;
};

struct FunY_Env
{
    int z;
};

union FuncRet foo(void *env, void *x)
{
    struct FunY_Env *yenv = malloc(sizeof(struct FunY_Env));
    yenv->z = (*(int *)x) + 5;
    return (union FuncRet){
        ._clos = (struct Closure){
            .env = yenv,
            .code_ptr = fun_y,
        },
    };
};

union FuncRet fun_y(void *env, void *y)
{
    struct FunY_Env *yenv = (struct FunY_Env *)env;
    int z = yenv->z;
    return (union FuncRet){
        ._val = (*(int *)y) + z,
    };
};

union FuncRet apply(struct Closure c, void *x)
{
    return c.code_ptr(c.env, x);
}

int main()
{
    int x = 1;
    int y = 2;
    struct Closure foo_clos = {
        .env = NULL,
        .code_ptr = foo,
    };
    int r = apply(apply(foo_clos, &x)._clos, &y)._val;
    printf("%d\n", r);
    return 0;
};