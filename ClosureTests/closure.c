#include <stdio.h>
#include <stdlib.h>

enum FuncRetTag
{
    INT,
    CLOSURE
};

typedef struct
{
    void **env;
    void *code_ptr;
} Closure;

typedef struct
{
    enum FuncRetTag tag;
    union
    {
        Closure closure;
        int int_ret;
    } ret_val;
} FuncRet;

FuncRet id(void **env, void *x);
FuncRet succ(void **env, void *x);
FuncRet compose(void **env, void *f);
FuncRet compose2(void **env, void *f);
FuncRet compose3(void **env, void *x);

// f
FuncRet id(void **env, void *x)
{
    int y = *(int *)x;
    return (FuncRet){
        .tag = INT,
        .ret_val.int_ret = y};
}

// g
FuncRet succ(void **env, void *x)
{
    int y = *(int *)x;
    return (FuncRet){
        .tag = INT,
        .ret_val.int_ret = y + 1,
    };
}
FuncRet apply(Closure c, void *x)
{
    FuncRet (*f)(void **, void *) = (FuncRet(*)(void **, void *))c.code_ptr;
    return f(c.env, x);
}

FuncRet compose(void **env, void *f)
{
    void **a = malloc(sizeof(void *));
    a[0] = f;
    return (FuncRet){
        .tag = CLOSURE,
        .ret_val = (Closure){
            .env = a,
            .code_ptr = (void *)compose2,
        },
    };
}

FuncRet compose2(void **env, void *g)
{
    void **a = malloc(sizeof(void *) * 2);
    a[0] = env[0];
    a[1] = g;

    return (FuncRet){
        .tag = CLOSURE,
        .ret_val = (Closure){
            .env = a,
            .code_ptr = (void *)compose3,
        },
    };
}

FuncRet compose3(void **env, void *x)
{
    FuncRet gx = apply(*(((Closure **)env)[1]), x);
    FuncRet fgx = apply(*(((Closure **)env)[0]), (void *)&gx.ret_val.int_ret);
    return fgx;
}

int main()
{
    Closure c = {
        .env = NULL,
        .code_ptr = compose,
    };
    Closure id_c = {
        .env = NULL,
        .code_ptr = id,
    };
    Closure succ_c = {
        .env = NULL,
        .code_ptr = succ,
    };
    void *f = &id_c;
    void *g = &succ_c;
    int i = 5;
    void *x = &i;

    int res = apply(apply(apply(c, f).ret_val.closure, g).ret_val.closure, x).ret_val.int_ret;
    printf("all of this shit just for a %d\n", res);
    return 0;
};