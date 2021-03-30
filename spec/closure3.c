#include <stdio.h>
#include <stdlib.h>

struct Clos_foldl1;
struct Clos_foldl2;
struct Clos_f;
struct Clos_f1;
struct List_Int;
struct Clos_f1 f(int arg0);
int f1(int arg0, int arg1);
struct Clos_foldl1 foldl(struct Clos_f arg0);
struct Clos_foldl2 foldl1(struct Clos_f arg0, int arg1);
int foldl2(struct Clos_f arg0, int arg1, struct List_Int *arg2);

struct List_Int {
    int tag;
    union {
        struct Nil {} *nil;
        struct Cons {
            int x; 
            struct List_Int *xs; 
        } cons;
    } value;
};

struct Clos_f {
    struct Clos_f1 (*code_ptr)(int a);
};
struct Clos_f1 {
    int (*code_ptr)(int a, int b);
    int arg0;
};

struct Clos_foldl {
    struct Clos_foldl1 (*code_ptr)(struct Clos_f arg0);
};
struct Clos_foldl1 {
    struct Clos_foldl2 (*code_ptr)(struct Clos_f arg0, int arg1);
    struct Clos_f arg0; 
};

struct Clos_foldl2 {
    int (*code_ptr)(struct Clos_f arg0, int arg1, struct List_Int *arg2);
    struct Clos_f arg0;   
    int arg1;   
};


struct Clos_foldl1 foldl(struct Clos_f arg0) {
    return (struct Clos_foldl1) { 
        .code_ptr = foldl1, 
        .arg0 = arg0 };
}
struct Clos_foldl2 foldl1(struct Clos_f arg0, int arg1) {
    return (struct Clos_foldl2) { .code_ptr = foldl2, .arg0 = arg0, .arg1 = arg1 };
}
struct Clos_f1 f(int arg0) {
    return (struct Clos_f1) {
        .code_ptr = f1,
        .arg0 = arg0
    };
}
int f1(int arg0, int arg1) {
    return arg0 + arg1;
}

int apply_foldl2(struct Clos_foldl2 clos, struct List_Int *arg2) {
    return (clos.code_ptr)(clos.arg0, clos.arg1, arg2);
}
struct Clos_foldl2 apply_foldl1(struct Clos_foldl1 clos, int arg1) {
    return (clos.code_ptr)(clos.arg0, arg1);
}
struct Clos_foldl1 apply_foldl(struct Clos_foldl clos, struct Clos_f arg0) {
    return (clos.code_ptr)(arg0);
}

int apply_f1(struct Clos_f1 clos, int arg1) {
    return (clos.code_ptr)(clos.arg0, arg1);
}
struct Clos_f1 apply_f(struct Clos_f clos, int arg0) {
    return (clos.code_ptr)(arg0);
}

int foldl2(struct Clos_f arg0, int arg1, struct List_Int *arg2)
{
    switch (arg2->tag) {
        case 0:
            return arg1;
        case 1: {
            int x = arg2->value.cons.x;
            struct List_Int *xs = arg2->value.cons.xs;
            return apply_foldl2(
                    apply_foldl1(
                    apply_foldl((struct Clos_foldl){ .code_ptr = foldl }, arg0), 
                    apply_f1(apply_f(arg0, arg1), x)), xs);
        }
    }
}

int main() {
    struct List_Int l2 = (struct List_Int) {
        .tag = 0,
        .value.nil = (struct Nil*) NULL
    };
    struct List_Int l1 = (struct List_Int) {
        .tag = 1,
        .value.cons = (struct Cons) {
            .x = 2,
            .xs = &l2
        }
    };
    struct List_Int l = (struct List_Int) { 
        .tag = 1, 
        .value.cons = (struct Cons) {
            .x = 1,
            .xs = &l1
        }
    };
    int res = apply_foldl2(
        apply_foldl1(
            apply_foldl((struct Clos_foldl) {.code_ptr = foldl}, 
            (struct Clos_f) { .code_ptr = f }), 0), &l);
    printf("%d\n", res);
    return 0;
}