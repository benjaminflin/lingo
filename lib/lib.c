#include <stdio.h>
#include <stdlib.h>

typedef struct adt
{
    long long tag;
    char *data;
} ADT;

typedef struct box
{
    char *a;
    char *b;
} Box;

typedef struct tuple
{
    Box a;
    Box b;
} Tuple;
ADT unit = (ADT){.tag = 0, .data = NULL};
long long print_int(long long t)
{
    printf("%lld\n", t);
    return 0;
}

char print_char(char c)
{
    printf("%c\n", c);
    return c;
}

int print_bool(int b)
{
    if (b == 0)
    {
        printf("false\n");
    }
    else if (b == 1)
    {
        printf("true\n");
    }
    return b;
}

ADT print_string(ADT adt)
{
    printf("%s\n", adt.data);
    return adt;
}
ADT prim_alloc(long long size)
{
    char *p = malloc((size_t)size);
    return (ADT){.tag = 0, .data = p};
}
ADT prim_drop(ADT d)
{
    free(d.data);
    return unit;
}
ADT set_bit(ADT adt, long long i, char c)
{
    adt.data[i] = c;
    return adt;
}
char *believe_me(char *x)
{
    return x;
}
ADT open_file(ADT filename, ADT filemode)
{
    FILE *fp = fopen(filename.data, filemode.data);
    char *data = (char *)fp;
    return (ADT){.tag = 0, .data = data};
}

ADT read_file(ADT file)
{
    FILE *fp = (FILE *)file.data;
    fseek(fp, 0L, SEEK_END);
    long size = ftell(fp);
    fseek(fp, 0L, SEEK_SET);
    char *data = malloc(size);
    fread(data, 1, size, fp);
    Tuple *tup = malloc(sizeof(Tuple));
    ADT mem;
    mem.tag = 0;
    mem.data = data;
    ADT file2;
    file2.tag = 0;
    file2.data = (char *)fp;
    tup->a = *((Box *)&mem);
    tup->b = *((Box *)&file2);
    return (ADT){.tag = 0, .data = (char *)tup};
}

ADT close_file(ADT file)
{
    FILE *fp = (FILE *)file.data;
    fclose(fp);
    return unit;
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
void __die__()
{
    fprintf(stderr, "Unhandled case, exiting.\n");
    exit(1);
}