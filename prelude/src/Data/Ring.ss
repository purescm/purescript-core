;; -*- mode: scheme -*-

(library (Data.Ring foreign)
  (export intSub
          numSub)
  (import (only (rnrs base) define lambda)
          (chezscheme))

  (define intSub
    (lambda (x)
      (lambda (y)
        (fx- x y))))

  (define numSub
    (lambda (x)
      (lambda (y)
        (fl- x y))))

)
