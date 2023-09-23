;; -*- mode: scheme -*-

(library (Data.EuclideanRing foreign)
  (export intDegree
          intDiv
          intMod
          numDiv)
  (import (only (rnrs base) define lambda if)
          (chezscheme))

  (define intDegree
    (lambda (x)
      (fxmin (fxabs x) (most-positive-fixnum))))

  (define intDiv
    (lambda (x)
      (lambda (y)
        (if (fx= y 0)
          0
          (fx/ x y)))))

  (define intMod
    (lambda (x)
      (lambda (y)
        (if (fx= y 0) 0
          (fxmod x y)))))

  (define numDiv
    (lambda (n1)
      (lambda (n2)
        (fl/ n1 n2))))
)
