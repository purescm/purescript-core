;; -*- mode: scheme -*-

(library (Data.HeytingAlgebra foreign)
  (export boolConj
          boolDisj
          boolNot)
  (import (only (rnrs base) define lambda error))

  (define boolConj 
    (lambda (b1)
      (lambda (b2)
        (error #f "Data.HeytingAlgebra:boolConj not implemented."))))

  (define boolDisj
    (lambda (b1)
      (lambda (b2)
        (error #f "Data.HeytingAlgebra:boolDisj not implemented."))))

  (define boolNot
    (lambda (b1)
      (lambda (b2)
        (error #f "Data.HeytingAlgebra:boolNot not implemented."))))

)
