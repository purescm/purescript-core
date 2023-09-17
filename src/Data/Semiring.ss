;; -*- mode: scheme -*-

(library (Data.Semiring foreign)
  (export intAdd
          intMul
          numAdd
          numMul)
  (import (only (rnrs base) define lambda)
          (chezscheme))

  (define intAdd
    (lambda (x)
      (lambda (y)
        (fx+ x y))))

  (define intMul
    (lambda (x)
      (lambda (y)
        (fx* x y))))

  (define numAdd
    (lambda (n1)
      (lambda (n2)
        (fl+ n1 n2))))

  (define numMul
    (lambda (n1)
      (lambda (n2)
        (fl* n1 n2))))

)
