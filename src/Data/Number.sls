;; -*- mode: scheme -*-

(library (Data.Number foreign)
  (export nan
          isNaN
          infinity
          isFinite
          fromStringImpl)
  (import (only (rnrs base) define lambda error quote))

  (define nan 'Data.Number:nan-NOT-DEFINED)

  (define isNaN
    (lambda (n)
      (error #f "Data.Number:isNan not implemented.")))

  (define infinity 'Data.Number:infinity-NOT-DEFINED)

  (define isFinite
    (lambda (n)
      (error #f "Data.Number:isFinite not implemented.")))

  (define fromStringImpl
    (lambda (str isFinite just nothing)
      (error #f "Data.Number:fromStringImpl not implemented.")))

)
