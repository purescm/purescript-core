;; -*- mode: scheme -*-

(library (Data.Int.Bits foreign)
  (export and
          or
          xor
          shl
          shr
          zshr
          complement)
  (import (only (rnrs base) define lambda)
          (only (chezscheme) fxlogand fxlogior fxlogxor fxsll fxsra fxsrl fxnot))

  (define and
    (lambda (n1)
      (lambda (n2)
        (fxlogand n1 n2))))

  (define or
    (lambda (n1)
      (lambda (n2)
        (fxlogior n1 n2))))

  (define xor
    (lambda (n1)
      (lambda (n2)
        (fxlogxor n1 n2))))

  (define shl
    (lambda (n1)
      (lambda (n2)
        (fxsll n1 n2))))

  (define shr
    (lambda (n1)
      (lambda (n2)
        (fxsra n1 n2))))

  (define zshr
    (lambda (n1)
      (lambda (n2)
        (fxsrl n1 n2))))

  (define complement fxnot)

)
