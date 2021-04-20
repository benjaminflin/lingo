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
	.globl	___prim_alloc__         ## -- Begin function __prim_alloc__
	.p2align	4, 0x90
___prim_alloc__:                        ## @__prim_alloc__
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
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	movq	(%r14), %rdi
	movq	%rdi, (%rsp)
	callq	_prim_alloc
	movq	%rax, (%rbx)
	movq	%rdx, 8(%rbx)
	movq	%rbx, %rax
	addq	$8, %rsp
	popq	%rbx
	popq	%r14
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___prim_drop__          ## -- Begin function __prim_drop__
	.p2align	4, 0x90
___prim_drop__:                         ## @__prim_drop__
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	subq	$24, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	movq	%rdi, %r14
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	movq	(%r14), %rax
	movq	8(%r14), %rcx
	movq	%rax, 8(%rsp)
	movq	%rcx, 16(%rsp)
	movq	8(%rsp), %rdi
	movq	16(%rsp), %rsi
	callq	_prim_drop
	movq	%rax, (%rbx)
	movq	%rdx, 8(%rbx)
	movq	%rbx, %rax
	addq	$24, %rsp
	popq	%rbx
	popq	%r14
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___print_string__       ## -- Begin function __print_string__
	.p2align	4, 0x90
___print_string__:                      ## @__print_string__
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	subq	$24, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	movq	%rdi, %r14
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	movq	(%r14), %rax
	movq	8(%r14), %rcx
	movq	%rax, 8(%rsp)
	movq	%rcx, 16(%rsp)
	movq	8(%rsp), %rdi
	movq	16(%rsp), %rsi
	callq	_print_string
	movq	%rax, (%rbx)
	movq	%rdx, 8(%rbx)
	movq	%rbx, %rax
	addq	$24, %rsp
	popq	%rbx
	popq	%r14
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
	.globl	___set_bit__            ## -- Begin function __set_bit__
	.p2align	4, 0x90
___set_bit__:                           ## @__set_bit__
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
	leaq	___set_bit__1(%rip), %rax
	movq	%rax, (%rbx)
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %r15
	movl	$16, %edi
	callq	_malloc
	movq	(%r14), %rcx
	movq	8(%r14), %rdx
	movq	%rcx, (%rax)
	movq	%rdx, 8(%rax)
	movq	%rax, (%r15)
	movq	%r15, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___set_bit__1           ## -- Begin function __set_bit__1
	.p2align	4, 0x90
___set_bit__1:                          ## @__set_bit__1
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%r12
	.cfi_def_cfa_offset 32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	pushq	%rax
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -40
	.cfi_offset %r12, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %r14
	movq	%rdi, %r15
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %r12
	leaq	___set_bit__2(%rip), %rax
	movq	%rax, (%r12)
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	movl	$8, %edi
	callq	_malloc
	movq	(%r15), %rcx
	movq	%rcx, (%rax)
	movq	%rax, (%rbx)
	movl	$16, %edi
	callq	_malloc
	movq	(%r14), %rcx
	movq	(%rcx), %rdx
	movq	8(%rcx), %rcx
	movq	%rcx, 8(%rax)
	movq	%rdx, (%rax)
	movq	%rax, 8(%rbx)
	movq	%rbx, 8(%r12)
	movq	%r12, %rax
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	___set_bit__2           ## -- Begin function __set_bit__2
	.p2align	4, 0x90
___set_bit__2:                          ## @__set_bit__2
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$32, %rsp
	.cfi_def_cfa_offset 64
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %r15
	movq	%rdi, %r14
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	movq	8(%r15), %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rax, 16(%rsp)
	movq	%rcx, 8(%rsp)
	movq	(%r15), %rax
	movq	(%rax), %rdx
	movq	%rdx, 24(%rsp)
	movzbl	(%r14), %ecx
	movb	%cl, 7(%rsp)
	movq	16(%rsp), %rsi
	movq	8(%rsp), %rdi
	callq	_set_bit
	movq	%rax, (%rbx)
	movq	%rdx, 8(%rbx)
	movq	%rbx, %rax
	addq	$32, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_len                    ## -- Begin function len
	.p2align	4, 0x90
_len:                                   ## @len
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	_fn_len(%rip), %rax
	movq	%rax, (%rbx)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_alloc                  ## -- Begin function alloc
	.p2align	4, 0x90
_alloc:                                 ## @alloc
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	_fn_alloc(%rip), %rax
	movq	%rax, (%rbx)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_drop                   ## -- Begin function drop
	.p2align	4, 0x90
_drop:                                  ## @drop
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	___prim_drop__(%rip), %rax
	movq	%rax, (%rbx)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	"_stringToMem'"         ## -- Begin function stringToMem'
	.p2align	4, 0x90
"_stringToMem'":                        ## @"stringToMem'"
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	"_fn_stringToMem'"(%rip), %rax
	movq	%rax, (%rbx)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_stringToMem            ## -- Begin function stringToMem
	.p2align	4, 0x90
_stringToMem:                           ## @stringToMem
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	_fn_stringToMem(%rip), %rax
	movq	%rax, (%rbx)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_printAndDrop           ## -- Begin function printAndDrop
	.p2align	4, 0x90
_printAndDrop:                          ## @printAndDrop
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	_fn_printAndDrop(%rip), %rax
	movq	%rax, (%rbx)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_const                  ## -- Begin function const
	.p2align	4, 0x90
_const:                                 ## @const
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	_fn_const(%rip), %rax
	movq	%rax, (%rbx)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_fn_len                 ## -- Begin function fn_len
	.p2align	4, 0x90
_fn_len:                                ## @fn_len
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
	subq	$40, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rdi, %rbx
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %r15
	movq	(%rbx), %rax
	movq	8(%rbx), %rcx
	movq	%rax, -80(%rbp)
	movq	%rcx, -72(%rbp)
	cmpq	$1, -80(%rbp)
	jne	LBB40_1
## %bb.2:                               ## %case
	movq	-72(%rbp), %rax
	movq	8(%rax), %rcx
	movq	%rcx, -64(%rbp)         ## 8-byte Spill
	movq	16(%rax), %rax
	movq	%rax, -56(%rbp)         ## 8-byte Spill
	movq	%rsp, %r14
	leaq	-16(%r14), %rsp
	movq	%rsp, %rbx
	leaq	-16(%rbx), %rsp
	leaq	___prim__plus(%rip), %rax
	movq	%rax, -16(%rbx)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, -8(%rbx)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movq	$1, -16(%rax)
	movq	-8(%rbx), %rsi
	callq	*-16(%rbx)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, -16(%r14)
	movq	%rax, -8(%r14)
	movq	%rsp, %r12
	leaq	-16(%r12), %rax
	movq	%rax, -48(%rbp)         ## 8-byte Spill
	movq	%rax, %rsp
	movq	%rsp, %r13
	leaq	-16(%r13), %rsp
	movq	%rsp, %rbx
	leaq	-16(%rbx), %rsp
	leaq	_len(%rip), %rax
	movq	%rax, -16(%rbx)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, -8(%rbx)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movq	$0, -16(%rax)
	movq	-8(%rbx), %rsi
	callq	*-16(%rbx)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, -16(%r13)
	movq	%rax, -8(%r13)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movq	-56(%rbp), %rcx         ## 8-byte Reload
	movq	%rcx, -8(%rax)
	movq	-64(%rbp), %rcx         ## 8-byte Reload
	movq	%rcx, -16(%rax)
	movq	-8(%r13), %rsi
	callq	*-16(%r13)
	movq	(%rax), %rax
	movq	%rax, -16(%r12)
	movq	-8(%r14), %rsi
	movq	-48(%rbp), %rdi         ## 8-byte Reload
	callq	*-16(%r14)
	movq	(%rax), %rax
	movq	%rax, (%r15)
	jmp	LBB40_3
LBB40_1:                                ## %default
	movq	$0, (%r15)
LBB40_3:                                ## %case_continue
	movq	%r15, %rax
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
	.globl	_fn_alloc               ## -- Begin function fn_alloc
	.p2align	4, 0x90
_fn_alloc:                              ## @fn_alloc
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
	leaq	_fn_alloc1(%rip), %rax
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
	.globl	_fn_alloc1              ## -- Begin function fn_alloc1
	.p2align	4, 0x90
_fn_alloc1:                             ## @fn_alloc1
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$64, %rsp
	.cfi_def_cfa_offset 96
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %r14
	movq	%rdi, %rbx
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %r15
	movq	(%rbx), %rax
	movq	8(%rbx), %rcx
	movq	%rax, 16(%rsp)
	movq	%rcx, 24(%rsp)
	leaq	___prim_alloc__(%rip), %rax
	movq	%rax, 32(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 40(%rsp)
	movq	(%r14), %rcx
	movq	(%rcx), %rcx
	movq	%rcx, 8(%rsp)
	leaq	8(%rsp), %rdi
	movq	%rax, %rsi
	callq	*32(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 48(%rsp)
	movq	%rax, 56(%rsp)
	movq	24(%rsp), %rsi
	leaq	48(%rsp), %rdi
	callq	*16(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, (%r15)
	movq	%rax, 8(%r15)
	movq	%r15, %rax
	addq	$64, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	"_fn_stringToMem'"      ## -- Begin function fn_stringToMem'
	.p2align	4, 0x90
"_fn_stringToMem'":                     ## @"fn_stringToMem'"
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
	leaq	"_fn_stringToMem'1"(%rip), %rax
	movq	%rax, (%rbx)
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %r15
	movl	$16, %edi
	callq	_malloc
	movq	(%r14), %rcx
	movq	8(%r14), %rdx
	movq	%rcx, (%rax)
	movq	%rdx, 8(%rax)
	movq	%rax, (%r15)
	movq	%r15, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	"_fn_stringToMem'1"     ## -- Begin function fn_stringToMem'1
	.p2align	4, 0x90
"_fn_stringToMem'1":                    ## @"fn_stringToMem'1"
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%r12
	.cfi_def_cfa_offset 32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	pushq	%rax
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -40
	.cfi_offset %r12, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %r14
	movq	%rdi, %r15
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %r12
	leaq	"_fn_stringToMem'2"(%rip), %rax
	movq	%rax, (%r12)
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	movl	$16, %edi
	callq	_malloc
	movq	(%r15), %rcx
	movq	8(%r15), %rdx
	movq	%rcx, (%rax)
	movq	%rdx, 8(%rax)
	movq	%rax, (%rbx)
	movl	$16, %edi
	callq	_malloc
	movq	(%r14), %rcx
	movq	(%rcx), %rdx
	movq	8(%rcx), %rcx
	movq	%rcx, 8(%rax)
	movq	%rdx, (%rax)
	movq	%rax, 8(%rbx)
	movq	%rbx, 8(%r12)
	movq	%r12, %rax
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	"_fn_stringToMem'2"     ## -- Begin function fn_stringToMem'2
	.p2align	4, 0x90
"_fn_stringToMem'2":                    ## @"fn_stringToMem'2"
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
	subq	$72, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rsi, %rbx
	movq	%rdi, %r13
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %r12
	movq	%rbx, -64(%rbp)         ## 8-byte Spill
	movq	8(%rbx), %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, -112(%rbp)
	movq	%rax, -104(%rbp)
	cmpq	$1, -112(%rbp)
	jne	LBB45_1
## %bb.2:                               ## %case
	movq	-104(%rbp), %rax
	movb	(%rax), %cl
	movb	%cl, -41(%rbp)          ## 1-byte Spill
	movq	8(%rax), %rcx
	movq	%rcx, -56(%rbp)         ## 8-byte Spill
	movq	%r12, -96(%rbp)         ## 8-byte Spill
	movq	16(%rax), %r12
	movq	%rsp, %rax
	movq	%rax, -88(%rbp)         ## 8-byte Spill
	leaq	-16(%rax), %rsp
	movq	%rsp, %r14
	leaq	-16(%r14), %rsp
	movq	%rsp, %rbx
	leaq	-16(%rbx), %rsp
	movq	%rsp, %r15
	leaq	-16(%r15), %rsp
	leaq	"_stringToMem'"(%rip), %rax
	movq	%rax, -16(%r15)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, -8(%r15)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movq	$0, -16(%rax)
	movq	-8(%r15), %rsi
	callq	*-16(%r15)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, -16(%rbx)
	movq	%rax, -8(%rbx)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -8(%rax)
	movq	-56(%rbp), %rcx         ## 8-byte Reload
	movq	%rcx, -16(%rax)
	movq	-8(%rbx), %rsi
	callq	*-16(%rbx)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%r14, -80(%rbp)         ## 8-byte Spill
	movq	%rcx, -16(%r14)
	movq	%rax, -8(%r14)
	movq	%rsp, %r15
	leaq	-16(%r15), %rax
	movq	%rax, -56(%rbp)         ## 8-byte Spill
	movq	%rax, %rsp
	movq	%rsp, %rbx
	leaq	-16(%rbx), %rsp
	movq	%rsp, %r12
	leaq	-16(%r12), %rsp
	movq	%r13, %r14
	movq	%r13, -72(%rbp)         ## 8-byte Spill
	movq	%rsp, %r13
	leaq	-16(%r13), %rsp
	leaq	___set_bit__(%rip), %rax
	movq	%rax, -16(%r13)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, -8(%r13)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movq	-64(%rbp), %rcx         ## 8-byte Reload
	movq	(%rcx), %rcx
	movq	(%rcx), %rdx
	movq	8(%rcx), %rcx
	movq	%rcx, -8(%rax)
	movq	%rdx, -16(%rax)
	movq	-8(%r13), %rsi
	callq	*-16(%r13)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, -16(%r12)
	movq	%rax, -8(%r12)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movq	(%r14), %rcx
	movq	%rcx, -16(%rax)
	movq	-8(%r12), %rsi
	callq	*-16(%r12)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, -16(%rbx)
	movq	%rax, -8(%rbx)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movb	-41(%rbp), %cl          ## 1-byte Reload
	movb	%cl, -16(%rax)
	movq	-8(%rbx), %rsi
	callq	*-16(%rbx)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, -16(%r15)
	movq	%rax, -8(%r15)
	movq	-80(%rbp), %rax         ## 8-byte Reload
	movq	-8(%rax), %rsi
	movq	-56(%rbp), %rdi         ## 8-byte Reload
	callq	*-16(%rax)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	-88(%rbp), %r13         ## 8-byte Reload
	movq	%rcx, -16(%r13)
	movq	%rax, -8(%r13)
	movq	%rsp, %r15
	leaq	-16(%r15), %r14
	movq	%r14, %rsp
	movq	%rsp, %r12
	leaq	-16(%r12), %rsp
	movq	%rsp, %rbx
	leaq	-16(%rbx), %rsp
	leaq	___prim__plus(%rip), %rax
	movq	%rax, -16(%rbx)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, -8(%rbx)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movq	-72(%rbp), %rcx         ## 8-byte Reload
	movq	(%rcx), %rcx
	movq	%rcx, -16(%rax)
	movq	-8(%rbx), %rsi
	callq	*-16(%rbx)
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
	movq	-96(%rbp), %r12         ## 8-byte Reload
	movq	(%rax), %rax
	movq	%rax, -16(%r15)
	movq	-8(%r13), %rsi
	movq	%r14, %rdi
	callq	*-16(%r13)
	jmp	LBB45_3
LBB45_1:                                ## %default
	movq	%rsp, %r14
	leaq	-16(%r14), %rsp
	movq	%rsp, %r15
	leaq	-16(%r15), %rsp
	movq	%rsp, %rbx
	leaq	-16(%rbx), %rsp
	leaq	___set_bit__(%rip), %rax
	movq	%rax, -16(%rbx)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, -8(%rbx)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movq	-64(%rbp), %rcx         ## 8-byte Reload
	movq	(%rcx), %rcx
	movq	(%rcx), %rdx
	movq	8(%rcx), %rcx
	movq	%rcx, -8(%rax)
	movq	%rdx, -16(%rax)
	movq	-8(%rbx), %rsi
	callq	*-16(%rbx)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, -16(%r15)
	movq	%rax, -8(%r15)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movq	(%r13), %rcx
	movq	%rcx, -16(%rax)
	movq	-8(%r15), %rsi
	callq	*-16(%r15)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, -16(%r14)
	movq	%rax, -8(%r14)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movb	$0, -16(%rax)
	movq	-8(%r14), %rsi
	callq	*-16(%r14)
LBB45_3:                                ## %case_continue
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, (%r12)
	movq	%rax, 8(%r12)
	movq	%r12, %rax
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
	.globl	_fn_stringToMem         ## -- Begin function fn_stringToMem
	.p2align	4, 0x90
_fn_stringToMem:                        ## @fn_stringToMem
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
	leaq	_fn_stringToMem1(%rip), %rax
	movq	%rax, (%rbx)
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %r15
	movl	$16, %edi
	callq	_malloc
	movq	(%r14), %rcx
	movq	8(%r14), %rdx
	movq	%rcx, (%rax)
	movq	%rdx, 8(%rax)
	movq	%rax, (%r15)
	movq	%r15, 8(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_fn_stringToMem1        ## -- Begin function fn_stringToMem1
	.p2align	4, 0x90
_fn_stringToMem1:                       ## @fn_stringToMem1
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%r12
	.cfi_def_cfa_offset 32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	subq	$184, %rsp
	.cfi_def_cfa_offset 224
	.cfi_offset %rbx, -40
	.cfi_offset %r12, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %r14
	movq	%rdi, %r15
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %r12
	leaq	_alloc(%rip), %rax
	movq	%rax, 168(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 176(%rsp)
	movq	$0, 64(%rsp)
	leaq	64(%rsp), %rdi
	movq	%rax, %rsi
	callq	*168(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 72(%rsp)
	movq	%rax, 80(%rsp)
	leaq	___prim__plus(%rip), %rax
	movq	%rax, 152(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 160(%rsp)
	movq	$1, 32(%rsp)
	leaq	32(%rsp), %rdi
	movq	%rax, %rsi
	callq	*152(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 40(%rsp)
	movq	%rax, 48(%rsp)
	leaq	_len(%rip), %rax
	movq	%rax, 136(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 144(%rsp)
	movq	$0, (%rsp)
	movq	%rsp, %rdi
	movq	%rax, %rsi
	callq	*136(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rax, 16(%rsp)
	movq	%rcx, 8(%rsp)
	movq	(%r14), %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rax, 128(%rsp)
	movq	%rcx, 120(%rsp)
	movq	16(%rsp), %rsi
	leaq	120(%rsp), %rdi
	callq	*8(%rsp)
	movq	(%rax), %rax
	movq	%rax, 24(%rsp)
	movq	48(%rsp), %rsi
	leaq	24(%rsp), %rdi
	callq	*40(%rsp)
	movq	(%rax), %rax
	movq	%rax, 56(%rsp)
	movq	80(%rsp), %rsi
	leaq	56(%rsp), %rdi
	callq	*72(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 88(%rsp)
	movq	%rax, 96(%rsp)
	leaq	_fn_stringToMem2(%rip), %rax
	movq	%rax, 104(%rsp)
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	movl	$16, %edi
	callq	_malloc
	movq	(%r15), %rcx
	movq	8(%r15), %rdx
	movq	%rcx, (%rax)
	movq	%rdx, 8(%rax)
	movq	%rax, (%rbx)
	movl	$16, %edi
	callq	_malloc
	movq	(%r14), %rcx
	movq	(%rcx), %rdx
	movq	8(%rcx), %rcx
	movq	%rcx, 8(%rax)
	movq	%rdx, (%rax)
	movq	%rax, 8(%rbx)
	movq	%rbx, 112(%rsp)
	movq	96(%rsp), %rsi
	leaq	104(%rsp), %rdi
	callq	*88(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, (%r12)
	movq	%rax, 8(%r12)
	movq	%r12, %rax
	addq	$184, %rsp
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_fn_stringToMem2        ## -- Begin function fn_stringToMem2
	.p2align	4, 0x90
_fn_stringToMem2:                       ## @fn_stringToMem2
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$144, %rsp
	.cfi_def_cfa_offset 176
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %rbx
	movq	%rdi, %r15
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %r14
	movq	(%rbx), %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rax, 72(%rsp)
	movq	%rcx, 64(%rsp)
	leaq	"_stringToMem'"(%rip), %rax
	movq	%rax, 112(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 120(%rsp)
	movq	$0, 8(%rsp)
	leaq	8(%rsp), %rdi
	movq	%rax, %rsi
	callq	*112(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rax, 24(%rsp)
	movq	%rcx, 16(%rsp)
	movq	8(%rbx), %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rax, 104(%rsp)
	movq	%rcx, 96(%rsp)
	movq	24(%rsp), %rsi
	leaq	96(%rsp), %rdi
	callq	*16(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rax, 40(%rsp)
	movq	%rcx, 32(%rsp)
	movq	(%r15), %rax
	movq	8(%r15), %rcx
	movq	%rcx, 88(%rsp)
	movq	%rax, 80(%rsp)
	movq	40(%rsp), %rsi
	leaq	80(%rsp), %rdi
	callq	*32(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rax, 56(%rsp)
	movq	%rcx, 48(%rsp)
	movq	$0, (%rsp)
	movq	56(%rsp), %rsi
	movq	%rsp, %rdi
	callq	*48(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 128(%rsp)
	movq	%rax, 136(%rsp)
	movq	72(%rsp), %rsi
	leaq	128(%rsp), %rdi
	callq	*64(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, (%r14)
	movq	%rax, 8(%r14)
	movq	%r14, %rax
	addq	$144, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_fn_printAndDrop        ## -- Begin function fn_printAndDrop
	.p2align	4, 0x90
_fn_printAndDrop:                       ## @fn_printAndDrop
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	subq	$88, %rsp
	.cfi_def_cfa_offset 112
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	movq	%rdi, %r14
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	_drop(%rip), %rax
	movq	%rax, 72(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 80(%rsp)
	movq	$0, (%rsp)
	movq	%rsp, %rdi
	movq	%rax, %rsi
	callq	*72(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 8(%rsp)
	movq	%rax, 16(%rsp)
	leaq	___print_string__(%rip), %rax
	movq	%rax, 40(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 48(%rsp)
	movq	(%r14), %rcx
	movq	8(%r14), %rdx
	movq	%rcx, 24(%rsp)
	movq	%rdx, 32(%rsp)
	leaq	24(%rsp), %rdi
	movq	%rax, %rsi
	callq	*40(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 56(%rsp)
	movq	%rax, 64(%rsp)
	movq	16(%rsp), %rsi
	leaq	56(%rsp), %rdi
	callq	*8(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, (%rbx)
	movq	%rax, 8(%rbx)
	movq	%rbx, %rax
	addq	$88, %rsp
	popq	%rbx
	popq	%r14
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_fn_const               ## -- Begin function fn_const
	.p2align	4, 0x90
_fn_const:                              ## @fn_const
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
	leaq	_fn_const1(%rip), %rax
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
	.globl	_fn_const1              ## -- Begin function fn_const1
	.p2align	4, 0x90
_fn_const1:                             ## @fn_const1
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	movq	%rsi, %rbx
	movl	$8, %edi
	callq	_malloc
	movq	(%rbx), %rcx
	movq	(%rcx), %rcx
	movq	%rcx, (%rax)
	popq	%rbx
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_C                      ## -- Begin function C
	.p2align	4, 0x90
_C:                                     ## @C
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
	leaq	_C1(%rip), %rax
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
	.globl	_C1                     ## -- Begin function C1
	.p2align	4, 0x90
_C1:                                    ## @C1
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%r13
	.cfi_def_cfa_offset 32
	pushq	%r12
	.cfi_def_cfa_offset 40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r13, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %r14
	movq	%rdi, %r15
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %r13
	movl	$1, %edi
	callq	_malloc
	movq	%rax, %r12
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	movq	(%r14), %rax
	movb	(%rax), %al
	movb	%al, (%r12)
	movq	(%r15), %rax
	movq	8(%r15), %rcx
	movq	%rcx, 8(%rbx)
	movq	%rax, (%rbx)
	movl	$24, %edi
	callq	_malloc
	movb	(%r12), %cl
	movb	%cl, (%rax)
	movq	(%rbx), %rcx
	movq	8(%rbx), %rdx
	movq	%rdx, 16(%rax)
	movq	%rcx, 8(%rax)
	movq	$1, (%r13)
	movq	%rax, 8(%r13)
	movq	%r13, %rax
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_main                   ## -- Begin function main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%rbx
	.cfi_def_cfa_offset 16
	subq	$336, %rsp              ## imm = 0x150
	.cfi_def_cfa_offset 352
	.cfi_offset %rbx, -16
	leaq	_const(%rip), %rax
	movq	%rax, 304(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 312(%rsp)
	movq	$0, 120(%rsp)
	leaq	120(%rsp), %rdi
	movq	%rax, %rsi
	callq	*304(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rax, 136(%rsp)
	movq	%rcx, 128(%rsp)
	movq	$0, 104(%rsp)
	leaq	104(%rsp), %rax
	movq	%rax, 112(%rsp)
	movq	136(%rsp), %rsi
	leaq	112(%rsp), %rdi
	callq	*128(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 144(%rsp)
	movq	%rax, 152(%rsp)
	leaq	_stringToMem(%rip), %rax
	movq	%rax, 272(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 280(%rsp)
	movq	$0, 56(%rsp)
	leaq	56(%rsp), %rdi
	movq	%rax, %rsi
	callq	*272(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 64(%rsp)
	movq	%rax, 72(%rsp)
	leaq	_C(%rip), %rbx
	movq	%rbx, 240(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 248(%rsp)
	movb	$104, 15(%rsp)
	leaq	15(%rsp), %rdi
	movq	%rax, %rsi
	callq	*240(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 40(%rsp)
	movq	%rax, 48(%rsp)
	movq	%rbx, 208(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 216(%rsp)
	movb	$105, 14(%rsp)
	leaq	14(%rsp), %rdi
	movq	%rax, %rsi
	callq	*208(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 24(%rsp)
	movq	%rax, 32(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	$0, 192(%rsp)
	movq	%rax, 200(%rsp)
	movq	32(%rsp), %rsi
	leaq	192(%rsp), %rdi
	callq	*24(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 224(%rsp)
	movq	%rax, 232(%rsp)
	movq	48(%rsp), %rsi
	leaq	224(%rsp), %rdi
	callq	*40(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 256(%rsp)
	movq	%rax, 264(%rsp)
	movq	72(%rsp), %rsi
	leaq	256(%rsp), %rdi
	callq	*64(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 80(%rsp)
	movq	%rax, 88(%rsp)
	leaq	_printAndDrop(%rip), %rax
	movq	%rax, 160(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 168(%rsp)
	movq	$0, 16(%rsp)
	leaq	16(%rsp), %rdi
	movq	%rax, %rsi
	callq	*160(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 176(%rsp)
	movq	%rax, 184(%rsp)
	movq	88(%rsp), %rsi
	leaq	176(%rsp), %rdi
	callq	*80(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 288(%rsp)
	movq	%rax, 296(%rsp)
	leaq	288(%rsp), %rax
	movq	%rax, 96(%rsp)
	movq	152(%rsp), %rsi
	leaq	96(%rsp), %rdi
	callq	*144(%rsp)
	movq	(%rax), %rax
	movq	%rax, 320(%rsp)
	movq	(%rax), %rax
	movq	%rax, 328(%rsp)
	addq	$336, %rsp              ## imm = 0x150
	popq	%rbx
	retq
	.cfi_endproc
                                        ## -- End function
.subsections_via_symbols
