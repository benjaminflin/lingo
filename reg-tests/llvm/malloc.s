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
	movq	%rax, %r14
	movq	(%rbx), %rax
	movq	8(%rbx), %rcx
	movq	%rax, -72(%rbp)
	movq	%rcx, -64(%rbp)
	cmpq	$1, -72(%rbp)
	jne	LBB33_1
## %bb.2:                               ## %case
	movq	-64(%rbp), %rax
	movq	8(%rax), %rcx
	movq	%rcx, -56(%rbp)         ## 8-byte Spill
	movq	16(%rax), %rax
	movq	%rax, -48(%rbp)         ## 8-byte Spill
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
	movq	$1, -16(%rax)
	movq	-8(%rbx), %rsi
	callq	*-16(%rbx)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, -16(%r12)
	movq	%rax, -8(%r12)
	movq	%rsp, %rbx
	leaq	-16(%rbx), %r15
	movq	%r15, %rsp
	movq	%rsp, %r13
	leaq	-16(%r13), %rsp
	leaq	_len(%rip), %rax
	movq	%rax, -16(%r13)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, -8(%r13)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movq	-48(%rbp), %rcx         ## 8-byte Reload
	movq	%rcx, -8(%rax)
	movq	-56(%rbp), %rcx         ## 8-byte Reload
	movq	%rcx, -16(%rax)
	movq	-8(%r13), %rsi
	callq	*-16(%r13)
	movq	(%rax), %rax
	movq	%rax, -16(%rbx)
	movq	-8(%r12), %rsi
	movq	%r15, %rdi
	callq	*-16(%r12)
	movq	(%rax), %rax
	movq	%rax, (%r14)
	jmp	LBB33_3
LBB33_1:                                ## %default
	movq	$0, (%r14)
LBB33_3:                                ## %case_continue
	movq	%r14, %rax
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
	.globl	_alloc                  ## -- Begin function alloc
	.p2align	4, 0x90
_alloc:                                 ## @alloc
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
	leaq	_alloc1(%rip), %rax
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
	.globl	_alloc1                 ## -- Begin function alloc1
	.p2align	4, 0x90
_alloc1:                                ## @alloc1
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
	.globl	_drop                   ## -- Begin function drop
	.p2align	4, 0x90
_drop:                                  ## @drop
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	subq	$40, %rsp
	.cfi_def_cfa_offset 64
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	movq	%rdi, %r14
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %rbx
	leaq	___prim_drop__(%rip), %rax
	movq	%rax, 24(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 32(%rsp)
	movq	(%r14), %rcx
	movq	8(%r14), %rdx
	movq	%rcx, 8(%rsp)
	movq	%rdx, 16(%rsp)
	leaq	8(%rsp), %rdi
	movq	%rax, %rsi
	callq	*24(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, (%rbx)
	movq	%rax, 8(%rbx)
	movq	%rbx, %rax
	addq	$40, %rsp
	popq	%rbx
	popq	%r14
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	"_stringToMem'"         ## -- Begin function stringToMem'
	.p2align	4, 0x90
"_stringToMem'":                        ## @"stringToMem'"
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
	leaq	"_stringToMem'1"(%rip), %rax
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
	.globl	"_stringToMem'1"        ## -- Begin function stringToMem'1
	.p2align	4, 0x90
"_stringToMem'1":                       ## @"stringToMem'1"
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
	leaq	"_stringToMem'2"(%rip), %rax
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
	.globl	"_stringToMem'2"        ## -- Begin function stringToMem'2
	.p2align	4, 0x90
"_stringToMem'2":                       ## @"stringToMem'2"
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
	movq	%rsi, %r13
	movq	%rdi, -56(%rbp)         ## 8-byte Spill
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %r12
	movq	8(%r13), %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, -104(%rbp)
	movq	%rax, -96(%rbp)
	cmpq	$1, -104(%rbp)
	jne	LBB39_1
## %bb.2:                               ## %case
	movq	-96(%rbp), %rax
	movb	(%rax), %cl
	movb	%cl, -41(%rbp)          ## 1-byte Spill
	movq	8(%rax), %r15
	movq	%r12, -88(%rbp)         ## 8-byte Spill
	movq	16(%rax), %r12
	movq	%rsp, %rax
	movq	%rax, -80(%rbp)         ## 8-byte Spill
	leaq	-16(%rax), %rsp
	movq	%rsp, %r14
	leaq	-16(%r14), %rsp
	movq	%rsp, %rbx
	leaq	-16(%rbx), %rsp
	leaq	"_stringToMem'"(%rip), %rax
	movq	%rax, -16(%rbx)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, -8(%rbx)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -8(%rax)
	movq	%r15, -16(%rax)
	movq	-8(%rbx), %rsi
	callq	*-16(%rbx)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, -16(%r14)
	movq	%rax, -8(%r14)
	movq	%rsp, %rax
	movq	%rax, -64(%rbp)         ## 8-byte Spill
	leaq	-16(%rax), %rax
	movq	%rax, -72(%rbp)         ## 8-byte Spill
	movq	%rax, %rsp
	movq	%rsp, %rbx
	leaq	-16(%rbx), %rsp
	movq	%rsp, %r12
	leaq	-16(%r12), %rsp
	movq	%rsp, %r15
	leaq	-16(%r15), %rsp
	leaq	___set_bit__(%rip), %rax
	movq	%rax, -16(%r15)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, -8(%r15)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movq	(%r13), %rcx
	movq	(%rcx), %rdx
	movq	8(%rcx), %rcx
	movq	%rcx, -8(%rax)
	movq	%rdx, -16(%rax)
	movq	-8(%r15), %rsi
	callq	*-16(%r15)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, -16(%r12)
	movq	%rax, -8(%r12)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movq	-56(%rbp), %rcx         ## 8-byte Reload
	movq	(%rcx), %rcx
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
	movq	-64(%rbp), %rdx         ## 8-byte Reload
	movq	%rcx, -16(%rdx)
	movq	%rax, -8(%rdx)
	movq	-8(%r14), %rsi
	movq	-72(%rbp), %rdi         ## 8-byte Reload
	callq	*-16(%r14)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	-80(%rbp), %r13         ## 8-byte Reload
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
	movq	-56(%rbp), %rcx         ## 8-byte Reload
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
	movq	-88(%rbp), %r12         ## 8-byte Reload
	movq	(%rax), %rax
	movq	%rax, -16(%r15)
	movq	-8(%r13), %rsi
	movq	%r14, %rdi
	callq	*-16(%r13)
	jmp	LBB39_3
LBB39_1:                                ## %default
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
	movq	(%r13), %rcx
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
	movq	-56(%rbp), %rcx         ## 8-byte Reload
	movq	(%rcx), %rcx
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
LBB39_3:                                ## %case_continue
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
	.globl	_stringToMem            ## -- Begin function stringToMem
	.p2align	4, 0x90
_stringToMem:                           ## @stringToMem
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
	leaq	_stringToMem1(%rip), %rax
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
	.globl	_stringToMem1           ## -- Begin function stringToMem1
	.p2align	4, 0x90
_stringToMem1:                          ## @stringToMem1
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
	subq	$136, %rsp
	.cfi_def_cfa_offset 176
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
	movq	%rax, 40(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 48(%rsp)
	leaq	___prim__plus(%rip), %rax
	movq	%rax, 120(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 128(%rsp)
	movq	$1, 8(%rsp)
	leaq	8(%rsp), %rdi
	movq	%rax, %rsi
	callq	*120(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 16(%rsp)
	movq	%rax, 24(%rsp)
	leaq	_len(%rip), %rax
	movq	%rax, 104(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 112(%rsp)
	movq	(%r14), %rcx
	movq	(%rcx), %rdx
	movq	8(%rcx), %rcx
	movq	%rcx, 96(%rsp)
	movq	%rdx, 88(%rsp)
	leaq	88(%rsp), %rdi
	movq	%rax, %rsi
	callq	*104(%rsp)
	movq	(%rax), %rax
	movq	%rax, (%rsp)
	movq	24(%rsp), %rsi
	movq	%rsp, %rdi
	callq	*16(%rsp)
	movq	(%rax), %rax
	movq	%rax, 32(%rsp)
	movq	48(%rsp), %rsi
	leaq	32(%rsp), %rdi
	callq	*40(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 56(%rsp)
	movq	%rax, 64(%rsp)
	leaq	_stringToMem2(%rip), %rax
	movq	%rax, 72(%rsp)
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
	movq	%rbx, 80(%rsp)
	movq	64(%rsp), %rsi
	leaq	72(%rsp), %rdi
	callq	*56(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, (%r12)
	movq	%rax, 8(%r12)
	movq	%r12, %rax
	addq	$136, %rsp
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_stringToMem2           ## -- Begin function stringToMem2
	.p2align	4, 0x90
_stringToMem2:                          ## @stringToMem2
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$128, %rsp
	.cfi_def_cfa_offset 160
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
	movq	%rax, 56(%rsp)
	movq	%rcx, 48(%rsp)
	leaq	"_stringToMem'"(%rip), %rax
	movq	%rax, 96(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 104(%rsp)
	movq	8(%rbx), %rcx
	movq	(%rcx), %rdx
	movq	8(%rcx), %rcx
	movq	%rcx, 88(%rsp)
	movq	%rdx, 80(%rsp)
	leaq	80(%rsp), %rdi
	movq	%rax, %rsi
	callq	*96(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rax, 24(%rsp)
	movq	%rcx, 16(%rsp)
	movq	(%r15), %rax
	movq	8(%r15), %rcx
	movq	%rcx, 72(%rsp)
	movq	%rax, 64(%rsp)
	movq	24(%rsp), %rsi
	leaq	64(%rsp), %rdi
	callq	*16(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rax, 40(%rsp)
	movq	%rcx, 32(%rsp)
	movq	$0, 8(%rsp)
	movq	40(%rsp), %rsi
	leaq	8(%rsp), %rdi
	callq	*32(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 112(%rsp)
	movq	%rax, 120(%rsp)
	movq	56(%rsp), %rsi
	leaq	112(%rsp), %rdi
	callq	*48(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, (%r14)
	movq	%rax, 8(%r14)
	movq	%r14, %rax
	addq	$128, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_printAndDrop           ## -- Begin function printAndDrop
	.p2align	4, 0x90
_printAndDrop:                          ## @printAndDrop
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	subq	$72, %rsp
	.cfi_def_cfa_offset 96
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	movq	%rdi, %rbx
	movl	$16, %edi
	callq	_malloc
	movq	%rax, %r14
	leaq	_drop(%rip), %rax
	movq	%rax, 8(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 16(%rsp)
	leaq	___print_string__(%rip), %rax
	movq	%rax, 40(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 48(%rsp)
	movq	(%rbx), %rcx
	movq	8(%rbx), %rdx
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
	movq	%rcx, (%r14)
	movq	%rax, 8(%r14)
	movq	%r14, %rax
	addq	$72, %rsp
	popq	%rbx
	popq	%r14
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_const                  ## -- Begin function const
	.p2align	4, 0x90
_const:                                 ## @const
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
	leaq	_const1(%rip), %rax
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
	.globl	_const1                 ## -- Begin function const1
	.p2align	4, 0x90
_const1:                                ## @const1
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
	subq	$240, %rsp
	.cfi_def_cfa_offset 256
	.cfi_offset %rbx, -16
	leaq	_const(%rip), %rax
	movq	%rax, 216(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 224(%rsp)
	movq	$0, 80(%rsp)
	leaq	80(%rsp), %rdi
	movq	%rax, %rsi
	callq	*216(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 88(%rsp)
	movq	%rax, 96(%rsp)
	leaq	_stringToMem(%rip), %rax
	movq	%rax, 48(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 56(%rsp)
	leaq	_C(%rip), %rbx
	movq	%rbx, 168(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 176(%rsp)
	movb	$104, 15(%rsp)
	leaq	15(%rsp), %rdi
	movq	%rax, %rsi
	callq	*168(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 32(%rsp)
	movq	%rax, 40(%rsp)
	movq	%rbx, 136(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 144(%rsp)
	movb	$105, 14(%rsp)
	leaq	14(%rsp), %rdi
	movq	%rax, %rsi
	callq	*136(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 16(%rsp)
	movq	%rax, 24(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	$0, 120(%rsp)
	movq	%rax, 128(%rsp)
	movq	24(%rsp), %rsi
	leaq	120(%rsp), %rdi
	callq	*16(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 152(%rsp)
	movq	%rax, 160(%rsp)
	movq	40(%rsp), %rsi
	leaq	152(%rsp), %rdi
	callq	*32(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 184(%rsp)
	movq	%rax, 192(%rsp)
	movq	56(%rsp), %rsi
	leaq	184(%rsp), %rdi
	callq	*48(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 64(%rsp)
	movq	%rax, 72(%rsp)
	leaq	_printAndDrop(%rip), %rax
	movq	%rax, 104(%rsp)
	xorl	%edi, %edi
	callq	_malloc
	movq	%rax, 112(%rsp)
	movq	72(%rsp), %rsi
	leaq	104(%rsp), %rdi
	callq	*64(%rsp)
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	%rcx, 200(%rsp)
	movq	%rax, 208(%rsp)
	movq	96(%rsp), %rsi
	leaq	200(%rsp), %rdi
	callq	*88(%rsp)
	movq	(%rax), %rax
	movq	%rax, 232(%rsp)
	addq	$240, %rsp
	popq	%rbx
	retq
	.cfi_endproc
                                        ## -- End function
.subsections_via_symbols
