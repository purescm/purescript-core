;; -*- mode: scheme -*-

(library (Data.Int foreign)
  (export fromNumberImpl
          toNumber
          fromStringAsImpl
          toStringAs
          quot
          rem
          pow)
  (import (only (rnrs base) define lambda error)
          (only (rnrs arithmetic flonums) fixnum->flonum))

  (define fromNumberImpl
    (lambda (just)
      (lambda (nothing)
        (lambda (n)
          (error #f "Data.Int:fromNumberImpl not implemented.")))))

  (define toNumber
    (lambda (n)
      (fixnum->flonum n)))

  (define fromStringAsImpl
    (lambda (just)
      (lambda (nothing)
        (lambda (radix)
          (error #f "Data.Int:fromStringasimpl not implemented.")))))

  (define toStringAs
    (lambda (radix)
      (lambda (i)
        (error #f "Data.Int:toStringAs not implemented."))))

  (define quot
    (lambda (x)
      (lambda (y)
        (error #f "Data.Int:quot not implemented."))))

  (define rem
    (lambda (x)
      (lambda (y)
        (error #f "Data.Int:rem not implemented."))))

  (define pow
    (lambda (x)
      (lambda (y)
        (error #f "Data.Int:pow not implemented."))))

)
