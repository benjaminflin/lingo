	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 15
	.globl	___prim__not            ## -- Begin function __prim__not
	.p2align	4, 0x90
___prim__not:                           ## @__prim__not
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	pushq	%rax
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	movq	%rdi, %r14
	movl	$1, %edi
	callq	_malloc
	movq	%rax, %rbx
	movzbl	(%r14), %edi
	movb	%dil, 7(%rsp)
	callq	___prim__unop__not
	andb	$1, %al
	movb	%al, (%rbx)
	movq	%rbx, %rax
	addq	$8, %rsp
	popq	%rbx
	popq	%r14
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__neg            ## -- Begin function __prim__neg
	.p2align	4, 0x90
___prim__neg:                           ## @__prim__neg
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	pushq	%rax
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	movq	%rdi, %r14
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %rbx
	movq	(%r14), %rdi
	movq	%rdi, (%rsp)
	callq	___prim__unop__neg
	movq	%rax, (%rbx)
	movq	%rbx, %rax
	addq	$8, %rsp
	popq	%rbx
	popq	%r14
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__or             ## -- Begin function __prim__or
	.p2align	4, 0x90
___prim__or:                            ## @__prim__or
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rdi, %r14
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	___prim__or1(%rip), %rax
	movq	%rax, (%rbx)
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %r15
	movl	$1, %edi
	callq	_malloc
	movb	(%r14), %cl
	movb	%cl, (%rax)
	movq	%rax, (%r15)
	movq	%r15, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__or1            ## -- Begin function __prim__or1
	.p2align	4, 0x90
___prim__or1:                           ## @__prim__or1
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %r15
	movq	%rdi, %r14
	movl	$1, %edi
	callq	_malloc
	movq	%rax, %rbx
	movq	(%r15), %rax
	movzbl	(%rax), %edi
	movb	%dil, 15(%rsp)
	movzbl	(%r14), %esi
	movb	%sil, 14(%rsp)
	callq	___prim__binop__or
	andb	$1, %al
	movb	%al, (%rbx)
	movq	%rbx, %rax
	addq	$16, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__and            ## -- Begin function __prim__and
	.p2align	4, 0x90
___prim__and:                           ## @__prim__and
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rdi, %r14
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	___prim__and1(%rip), %rax
	movq	%rax, (%rbx)
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %r15
	movl	$1, %edi
	callq	_malloc
	movb	(%r14), %cl
	movb	%cl, (%rax)
	movq	%rax, (%r15)
	movq	%r15, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__and1           ## -- Begin function __prim__and1
	.p2align	4, 0x90
___prim__and1:                          ## @__prim__and1
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %r15
	movq	%rdi, %r14
	movl	$1, %edi
	callq	_malloc
	movq	%rax, %rbx
	movq	(%r15), %rax
	movzbl	(%rax), %edi
	movb	%dil, 15(%rsp)
	movzbl	(%r14), %esi
	movb	%sil, 14(%rsp)
	callq	___prim__binop__and
	andb	$1, %al
	movb	%al, (%rbx)
	movq	%rbx, %rax
	addq	$16, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__neq            ## -- Begin function __prim__neq
	.p2align	4, 0x90
___prim__neq:                           ## @__prim__neq
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rdi, %r14
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	___prim__neq1(%rip), %rax
	movq	%rax, (%rbx)
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %r15
	movl	$8, %edi
	callq	_malloc
	movq	(%r14), %rcx
	movq	%rcx, (%rax)
	movq	%rax, (%r15)
	movq	%r15, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__neq1           ## -- Begin function __prim__neq1
	.p2align	4, 0x90
___prim__neq1:                          ## @__prim__neq1
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %r15
	movq	%rdi, %r14
	movl	$1, %edi
	callq	_malloc
	movq	%rax, %rbx
	movq	(%r15), %rax
	movq	(%rax), %rdi
	movq	%rdi, 8(%rsp)
	movq	(%r14), %rsi
	movq	%rsi, (%rsp)
	callq	___prim__binop__neq
	andb	$1, %al
	movb	%al, (%rbx)
	movq	%rbx, %rax
	addq	$16, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__lt             ## -- Begin function __prim__lt
	.p2align	4, 0x90
___prim__lt:                            ## @__prim__lt
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rdi, %r14
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	___prim__lt1(%rip), %rax
	movq	%rax, (%rbx)
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %r15
	movl	$8, %edi
	callq	_malloc
	movq	(%r14), %rcx
	movq	%rcx, (%rax)
	movq	%rax, (%r15)
	movq	%r15, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__lt1            ## -- Begin function __prim__lt1
	.p2align	4, 0x90
___prim__lt1:                           ## @__prim__lt1
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %r15
	movq	%rdi, %r14
	movl	$1, %edi
	callq	_malloc
	movq	%rax, %rbx
	movq	(%r15), %rax
	movq	(%rax), %rdi
	movq	%rdi, 8(%rsp)
	movq	(%r14), %rsi
	movq	%rsi, (%rsp)
	callq	___prim__binop__lt
	andb	$1, %al
	movb	%al, (%rbx)
	movq	%rbx, %rax
	addq	$16, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__leq            ## -- Begin function __prim__leq
	.p2align	4, 0x90
___prim__leq:                           ## @__prim__leq
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rdi, %r14
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	___prim__leq1(%rip), %rax
	movq	%rax, (%rbx)
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %r15
	movl	$8, %edi
	callq	_malloc
	movq	(%r14), %rcx
	movq	%rcx, (%rax)
	movq	%rax, (%r15)
	movq	%r15, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__leq1           ## -- Begin function __prim__leq1
	.p2align	4, 0x90
___prim__leq1:                          ## @__prim__leq1
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %r15
	movq	%rdi, %r14
	movl	$1, %edi
	callq	_malloc
	movq	%rax, %rbx
	movq	(%r15), %rax
	movq	(%rax), %rdi
	movq	%rdi, 8(%rsp)
	movq	(%r14), %rsi
	movq	%rsi, (%rsp)
	callq	___prim__binop__leq
	andb	$1, %al
	movb	%al, (%rbx)
	movq	%rbx, %rax
	addq	$16, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__eq             ## -- Begin function __prim__eq
	.p2align	4, 0x90
___prim__eq:                            ## @__prim__eq
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rdi, %r14
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	___prim__eq1(%rip), %rax
	movq	%rax, (%rbx)
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %r15
	movl	$8, %edi
	callq	_malloc
	movq	(%r14), %rcx
	movq	%rcx, (%rax)
	movq	%rax, (%r15)
	movq	%r15, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__eq1            ## -- Begin function __prim__eq1
	.p2align	4, 0x90
___prim__eq1:                           ## @__prim__eq1
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %r15
	movq	%rdi, %r14
	movl	$1, %edi
	callq	_malloc
	movq	%rax, %rbx
	movq	(%r15), %rax
	movq	(%rax), %rdi
	movq	%rdi, 8(%rsp)
	movq	(%r14), %rsi
	movq	%rsi, (%rsp)
	callq	___prim__binop__eq
	andb	$1, %al
	movb	%al, (%rbx)
	movq	%rbx, %rax
	addq	$16, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__gt             ## -- Begin function __prim__gt
	.p2align	4, 0x90
___prim__gt:                            ## @__prim__gt
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rdi, %r14
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	___prim__gt1(%rip), %rax
	movq	%rax, (%rbx)
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %r15
	movl	$8, %edi
	callq	_malloc
	movq	(%r14), %rcx
	movq	%rcx, (%rax)
	movq	%rax, (%r15)
	movq	%r15, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__gt1            ## -- Begin function __prim__gt1
	.p2align	4, 0x90
___prim__gt1:                           ## @__prim__gt1
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %r15
	movq	%rdi, %r14
	movl	$1, %edi
	callq	_malloc
	movq	%rax, %rbx
	movq	(%r15), %rax
	movq	(%rax), %rdi
	movq	%rdi, 8(%rsp)
	movq	(%r14), %rsi
	movq	%rsi, (%rsp)
	callq	___prim__binop__gt
	andb	$1, %al
	movb	%al, (%rbx)
	movq	%rbx, %rax
	addq	$16, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__geq            ## -- Begin function __prim__geq
	.p2align	4, 0x90
___prim__geq:                           ## @__prim__geq
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rdi, %r14
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	___prim__geq1(%rip), %rax
	movq	%rax, (%rbx)
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %r15
	movl	$8, %edi
	callq	_malloc
	movq	(%r14), %rcx
	movq	%rcx, (%rax)
	movq	%rax, (%r15)
	movq	%r15, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__geq1           ## -- Begin function __prim__geq1
	.p2align	4, 0x90
___prim__geq1:                          ## @__prim__geq1
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %r15
	movq	%rdi, %r14
	movl	$1, %edi
	callq	_malloc
	movq	%rax, %rbx
	movq	(%r15), %rax
	movq	(%rax), %rdi
	movq	%rdi, 8(%rsp)
	movq	(%r14), %rsi
	movq	%rsi, (%rsp)
	callq	___prim__binop__geq
	andb	$1, %al
	movb	%al, (%rbx)
	movq	%rbx, %rax
	addq	$16, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__divide         ## -- Begin function __prim__divide
	.p2align	4, 0x90
___prim__divide:                        ## @__prim__divide
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rdi, %r14
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	___prim__divide1(%rip), %rax
	movq	%rax, (%rbx)
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %r15
	movl	$8, %edi
	callq	_malloc
	movq	(%r14), %rcx
	movq	%rcx, (%rax)
	movq	%rax, (%r15)
	movq	%r15, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__divide1        ## -- Begin function __prim__divide1
	.p2align	4, 0x90
___prim__divide1:                       ## @__prim__divide1
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %r15
	movq	%rdi, %r14
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %rbx
	movq	(%r15), %rax
	movq	(%rax), %rdi
	movq	%rdi, 8(%rsp)
	movq	(%r14), %rsi
	movq	%rsi, (%rsp)
	callq	___prim__binop__divide
	movq	%rax, (%rbx)
	movq	%rbx, %rax
	addq	$16, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__times          ## -- Begin function __prim__times
	.p2align	4, 0x90
___prim__times:                         ## @__prim__times
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rdi, %r14
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	___prim__times1(%rip), %rax
	movq	%rax, (%rbx)
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %r15
	movl	$8, %edi
	callq	_malloc
	movq	(%r14), %rcx
	movq	%rcx, (%rax)
	movq	%rax, (%r15)
	movq	%r15, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__times1         ## -- Begin function __prim__times1
	.p2align	4, 0x90
___prim__times1:                        ## @__prim__times1
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %r15
	movq	%rdi, %r14
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %rbx
	movq	(%r15), %rax
	movq	(%rax), %rdi
	movq	%rdi, 8(%rsp)
	movq	(%r14), %rsi
	movq	%rsi, (%rsp)
	callq	___prim__binop__times
	movq	%rax, (%rbx)
	movq	%rbx, %rax
	addq	$16, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__minus          ## -- Begin function __prim__minus
	.p2align	4, 0x90
___prim__minus:                         ## @__prim__minus
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rdi, %r14
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	___prim__minus1(%rip), %rax
	movq	%rax, (%rbx)
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %r15
	movl	$8, %edi
	callq	_malloc
	movq	(%r14), %rcx
	movq	%rcx, (%rax)
	movq	%rax, (%r15)
	movq	%r15, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__minus1         ## -- Begin function __prim__minus1
	.p2align	4, 0x90
___prim__minus1:                        ## @__prim__minus1
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %r15
	movq	%rdi, %r14
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %rbx
	movq	(%r15), %rax
	movq	(%rax), %rdi
	movq	%rdi, 8(%rsp)
	movq	(%r14), %rsi
	movq	%rsi, (%rsp)
	callq	___prim__binop__minus
	movq	%rax, (%rbx)
	movq	%rbx, %rax
	addq	$16, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__plus           ## -- Begin function __prim__plus
	.p2align	4, 0x90
___prim__plus:                          ## @__prim__plus
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rdi, %r14
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	___prim__plus1(%rip), %rax
	movq	%rax, (%rbx)
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %r15
	movl	$8, %edi
	callq	_malloc
	movq	(%r14), %rcx
	movq	%rcx, (%rax)
	movq	%rax, (%r15)
	movq	%r15, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim__plus1          ## -- Begin function __prim__plus1
	.p2align	4, 0x90
___prim__plus1:                         ## @__prim__plus1
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %r15
	movq	%rdi, %r14
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %rbx
	movq	(%r15), %rax
	movq	(%rax), %rdi
	movq	%rdi, 8(%rsp)
	movq	(%r14), %rsi
	movq	%rsi, (%rsp)
	callq	___prim__binop__plus
	movq	%rax, (%rbx)
	movq	%rbx, %rax
	addq	$16, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___print_int__          ## -- Begin function __print_int__
	.p2align	4, 0x90
___print_int__:                         ## @__print_int__
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	pushq	%rax
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	movq	%rdi, %r14
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %rbx
	movq	(%r14), %rdi
	movq	%rdi, (%rsp)
	callq	_print_int
	movq	%rax, (%rbx)
	movq	%rbx, %rax
	addq	$8, %rsp
	popq	%rbx
	popq	%r14
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_f                      ## -- Begin function f
	.p2align	4, 0x90
_f:                                     ## @f
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$104, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rdi, %r13
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	___prim__eq(%rip), %rax
	movq	%rax, -136(%rbp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, -128(%rbp)
	movq	(%r13), %rcx
	movq	%rcx, -104(%rbp)
	leaq	-104(%rbp), %rdi
	movq	%rax, %rsi
	callq	*-136(%rbp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rax, -112(%rbp)
	movq	%rcx, -120(%rbp)
	movq	$0, -96(%rbp)
	movq	-112(%rbp), %rsi
	leaq	-96(%rbp), %rdi
	callq	*-120(%rbp)
	movb	(%rax), %al
	movb	%al, -41(%rbp)
	cmpb	$1, %al
	jne	LBB27_2
## %bb.1:                               ## %brtrue
	movq	$1, (%rbx)
	jmp	LBB27_3
LBB27_2:                                ## %brfalse
	movq	%rsp, %r14
	leaq	-16(%r14), %rsp
	movq	%rbx, -88(%rbp)         ## 8-byte Spill
	movq	%rsp, %rbx
	leaq	-16(%rbx), %rsp
	leaq	___prim__times(%rip), %rax
	movq	%rax, -16(%rbx)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, -8(%rbx)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movq	(%r13), %rcx
	movq	%rcx, -16(%rax)
	movq	-8(%rbx), %rsi
	callq	*-16(%rbx)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, -16(%r14)
	movq	%rax, -8(%r14)
	movq	%rsp, %rax
	movq	%rax, -72(%rbp)         ## 8-byte Spill
	leaq	-16(%rax), %rax
	movq	%rax, -80(%rbp)         ## 8-byte Spill
	movq	%rax, %rsp
	movq	%rsp, %r15
	leaq	-16(%r15), %rsp
	leaq	_f(%rip), %rax
	movq	%rax, -16(%r15)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, -8(%r15)
	movq	%rsp, %rax
	movq	%rax, -56(%rbp)         ## 8-byte Spill
	addq	$-16, %rax
	movq	%rax, -64(%rbp)         ## 8-byte Spill
	movq	%rax, %rsp
	movq	%rsp, %r12
	leaq	-16(%r12), %rsp
	movq	%rsp, %rbx
	leaq	-16(%rbx), %rsp
	leaq	___prim__minus(%rip), %rax
	movq	%rax, -16(%rbx)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, -8(%rbx)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movq	(%r13), %rcx
	movq	%rcx, -16(%rax)
	movq	-8(%rbx), %rsi
	callq	*-16(%rbx)
	movq	-88(%rbp), %rbx         ## 8-byte Reload
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, -16(%r12)
	movq	%rax, -8(%r12)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movq	$1, -16(%rax)
	movq	-8(%r12), %rsi
	callq	*-16(%r12)
	movq	(%rax), %rax
	movq	-56(%rbp), %rcx         ## 8-byte Reload
	movq	%rax, -16(%rcx)
	movq	-8(%r15), %rsi
	movq	-64(%rbp), %rdi         ## 8-byte Reload
	callq	*-16(%r15)
	movq	(%rax), %rax
	movq	-72(%rbp), %rcx         ## 8-byte Reload
	movq	%rax, -16(%rcx)
	movq	-8(%r14), %rsi
	movq	-80(%rbp), %rdi         ## 8-byte Reload
	callq	*-16(%r14)
	movq	(%rax), %rax
	movq	%rax, (%rbx)
LBB27_3:                                ## %end
	movq	%rbx, %rax
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_main                   ## -- Begin function main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## %bb.0:                               ## %entry
	subq	$56, %rsp
	.cfi_def_cfa_offset 64
	leaq	___print_int__(%rip), %rax
	movq	%rax, 16(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 24(%rsp)
	leaq	_f(%rip), %rax
	movq	%rax, 32(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 40(%rsp)
	movq	$5, (%rsp)
	movq	%rsp, %rdi
	movq	%rax, %rsi
	callq	*32(%rsp)
	movq	(%rax), %rax
	movq	%rax, 8(%rsp)
	movq	24(%rsp), %rsi
	leaq	8(%rsp), %rdi
	callq	*16(%rsp)
	movq	(%rax), %rax
	movq	%rax, 48(%rsp)
	addq	$56, %rsp
	retq
	.cfi_endproc
                                        ## -- End function
.subsections_via_symbols
