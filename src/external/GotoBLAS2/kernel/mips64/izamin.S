/*********************************************************************/
/*                                                                   */
/*             Optimized BLAS libraries                              */
/*                     By Kazushige Goto <kgoto@tacc.utexas.edu>     */
/*                                                                   */
/* Copyright (c) The University of Texas, 2009. All rights reserved. */
/* UNIVERSITY EXPRESSLY DISCLAIMS ANY AND ALL WARRANTIES CONCERNING  */
/* THIS SOFTWARE AND DOCUMENTATION, INCLUDING ANY WARRANTIES OF      */
/* MERCHANTABILITY, FITNESS FOR ANY PARTICULAR PURPOSE,              */
/* NON-INFRINGEMENT AND WARRANTIES OF PERFORMANCE, AND ANY WARRANTY  */
/* THAT MIGHT OTHERWISE ARISE FROM COURSE OF DEALING OR USAGE OF     */
/* TRADE. NO WARRANTY IS EITHER EXPRESS OR IMPLIED WITH RESPECT TO   */
/* THE USE OF THE SOFTWARE OR DOCUMENTATION.                         */
/* Under no circumstances shall University be liable for incidental, */
/* special, indirect, direct or consequential damages or loss of     */
/* profits, interruption of business, or related expenses which may  */
/* arise from use of Software or Documentation, including but not    */
/* limited to those resulting from defects in Software and/or        */
/* Documentation, or loss or inaccuracy of data of any kind.         */
/*********************************************************************/

#define ASSEMBLER
#include "common.h"

#define N	$4
#define	X	$5
#define INCX	$6
	
#define I	$3
#define TEMP	$7

#define a1	$f4
#define a2	$f5
#define a3	$f6
#define a4	$f7
#define a5	$f8
#define a6	$f9
#define a7	$f10
#define a8	$f11

#define t1	$f12
#define t2	$f13
#define t3	$f14
#define t4	$f15
#define t5	$f16
#define t6	$f17
#define t7	$f18
#define t8	$f19

#define s1	$f0
#define s2	$f1
#define s3	$f2
#define s4	$f3

#define	x1	$2
#define	x2	$8
#define	x3	$9
#define	x4	$10
	
	PROLOGUE
	
#ifdef F_INTERFACE
	LDINT	N,     0(N)
	LDINT	INCX,  0(INCX)
#endif

	blez	N, .L999
	li	x1, 0

	blez	INCX, .L999
	dsll	INCX, INCX, ZBASE_SHIFT

	LD	a1,  0 * SIZE(X)
	LD	a2,  1 * SIZE(X)

	FABS	t1, a1
	FABS	t2, a2
	
	ADD	s1, t1, t2
	ADD	s2, t1, t2
	ADD	s3, t1, t2
	ADD	s4, t1, t2

	daddiu	N, N, -1

	blez	N, .L999
	li	x1, 1

	daddu	X, X, INCX
	li	x2, 1

	dsra	I, N, 2
	li	x3, 1

	li	TEMP, 2

	blez	I, .L15
	li	x4, 1

	LD	a1,  0 * SIZE(X)
	LD	a2,  1 * SIZE(X)
	daddu	X, X, INCX
	LD	a3,  0 * SIZE(X)
	LD	a4,  1 * SIZE(X)
	daddu	X, X, INCX
	LD	a5,  0 * SIZE(X)
	LD	a6,  1 * SIZE(X)
	daddu	X, X, INCX
	LD	a7,  0 * SIZE(X)
	LD	a8,  1 * SIZE(X)
	daddiu	I, I, -1

	blez	I, .L13
	daddu	X, X, INCX
	.align 3

.L12:
	FABS	t1, a1
	LD	a1,  0 * SIZE(X)
	FABS	t2, a2
	LD	a2,  1 * SIZE(X)

	FABS	t3, a3
	daddu	X, X, INCX
	FABS	t4, a4
	NOP

	FABS	t5, a5
	LD	a3,  0 * SIZE(X)
	FABS	t6, a6
	LD	a4,  1 * SIZE(X)
	FABS	t7, a7
	daddu	X, X, INCX
	FABS	t8, a8
	NOP

	ADD	t1, t1, t2
	LD	a5,  0 * SIZE(X)
	ADD	t3, t3, t4
	LD	a6,  1 * SIZE(X)
	ADD	t5, t5, t6
	daddu	X, X, INCX
	ADD	t7, t7, t8
	NOP

	CMPLT	$fcc0, t1, s1
	LD	a7,  0 * SIZE(X)
	CMPLT	$fcc1, t3, s2
	LD	a8,  1 * SIZE(X)
	CMPLT	$fcc2, t5, s3
	daddu	X, X, INCX
	CMPLT	$fcc3, t7, s4
	daddiu	I, I, -1

	CMOVT	s1, t1, $fcc0
	movt	x1, TEMP, $fcc0
	CMOVT	s2, t3, $fcc1
	movt	x2, TEMP, $fcc1

	CMOVT	s3, t5, $fcc2
	movt	x3, TEMP, $fcc2
	CMOVT	s4, t7, $fcc3
	movt	x4, TEMP, $fcc3

	bgtz	I, .L12
	daddiu	TEMP, TEMP, 4
	.align 3

.L13:
	FABS	t1, a1
	FABS	t2, a2
	FABS	t3, a3
	FABS	t4, a4

	FABS	t5, a5
	FABS	t6, a6
	FABS	t7, a7
	FABS	t8, a8

	ADD	t1, t1, t2
	ADD	t3, t3, t4
	ADD	t5, t5, t6
	ADD	t7, t7, t8

	CMPLT	$fcc0, t1, s1
	CMPLT	$fcc1, t3, s2
	CMPLT	$fcc2, t5, s3
	CMPLT	$fcc3, t7, s4

	CMOVT	s1, t1, $fcc0
	movt	x1, TEMP, $fcc0
	CMOVT	s2, t3, $fcc1
	movt	x2, TEMP, $fcc1

	CMOVT	s3, t5, $fcc2
	movt	x3, TEMP, $fcc2
	CMOVT	s4, t7, $fcc3
	movt	x4, TEMP, $fcc3

	daddiu	TEMP, TEMP, 4
	daddiu	x2, x2, 1
	daddiu	x3, x3, 2
	daddiu	x4, x4, 3
	.align 3

.L15:
	andi	I,  N, 3
	blez	I, .L998
	NOP
	.align	3

.L16:
	LD	a1,  0 * SIZE(X)
	LD	a2,  1 * SIZE(X)
	daddu	X, X, INCX

	FABS	t1, a1
	FABS	t2, a2

	ADD	t1, t1, t2

	daddiu	I, I, -1

	CMPLT	$fcc0, t1, s1
	NOP
	CMOVT	s1, t1, $fcc0
	movt	x1, TEMP, $fcc0

	bgtz	I, .L16
	daddiu	TEMP, TEMP, 1
	.align 3

.L998:
	CMPLT	$fcc0, s2, s1
	CMPLT	$fcc1, s4, s3

	CMOVT	s1, s2, $fcc0
	movt	x1, x2, $fcc0
	CMOVT	s3, s4, $fcc1
	movt	x3, x4, $fcc1

	CMPLT	$fcc0, s3, s1
	CMOVT	s1, s3, $fcc0
	movt	x1, x3, $fcc0
	.align 3

.L999:
	j	$31
	NOP

	EPILOGUE
