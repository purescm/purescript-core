;; -*- mode: scheme -*-

(library (Data.Eq foreign)
  (export eqBooleanImpl
          eqIntImpl
          eqNumberImpl
          eqCharImpl
          eqStringImpl
          eqArrayImpl)
  (import (only (rnrs base) define lambda error))

  (define eqBooleanImpl
    (lambda (r1)
      (lambda (r2)
        (error #f "Data.Eq:eqBooleanImpl not implemented."))))

  (define eqIntImpl
    (lambda (r1)
      (lambda (r2)
        (error #f "Data.Eq:eqIntImpl not implemented."))))

  (define eqNumberImpl
    (lambda (r1)
      (lambda (r2)
        (error #f "Data.Eq:eqNumberImpl not implemented."))))

  (define eqCharImpl
    (lambda (r1)
      (lambda (r2)
        (error #f "Data.Eq:eqCharImpl not implemented."))))

  (define eqStringImpl
    (lambda (r1)
      (lambda (r2)
        (error #f "Data.Eq:eqStringImpl not implemented."))))

  (define eqArrayImpl
    (lambda (f)
      (lambda (xs)
        (lambda (ys)
          (error #f "Data.Eq:eqArrayImpl is not implemented.")))))

)
