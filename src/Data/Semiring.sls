;; -*- mode: scheme -*-

(library (Data.Semiring foreign)
  (export intAdd
          intMul
          numAdd
          numMul)
  (import (only (rnrs base) define lambda error))

  (define intAdd
    (lambda (x)
      (lambda (y)
        (error #f "Data.Semiring:intAdd not implemented."))))

  (define intMul
    (lambda (x)
      (lambda (y)
        (error #f "Data.Semiring:intMul not implemented."))))

  (define numAdd
    (lambda (n1)
      (lambda (n2)
        (error #f "Data.Semiring:numAdd not implemented."))))

  (define numMul
    (lambda (n1)
      (lambda (n2)
        (error #f "Data.Semiring:numMul not implemented."))))

)
