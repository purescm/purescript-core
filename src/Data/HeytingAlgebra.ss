;; -*- mode: scheme -*-

(library (Data.HeytingAlgebra foreign)
  (export boolConj
          boolDisj
          boolNot)
  (import (only (rnrs base) define lambda and or not))

  (define boolConj 
    (lambda (b1)
      (lambda (b2)
        (and b1 b2))))

  (define boolDisj
    (lambda (b1)
      (lambda (b2)
        (or b1 b2))))

  (define boolNot not)

)
