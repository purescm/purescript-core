;; -*- mode: scheme -*-

(library (Data.Eq foreign)
  (export eqBooleanImpl
          eqIntImpl
          eqNumberImpl
          eqCharImpl
          eqStringImpl
          eqArrayImpl)
  (import (chezscheme))
  (import (only (rnrs base) define lambda)
          (only (purescm pstring) pstring=?)
          (prefix (srfi :214) srfi:214:))

  (define eqBooleanImpl
    (lambda (r1)
      (lambda (r2)
        (eq? r1 r2))))

  (define eqIntImpl
    (lambda (r1)
      (lambda (r2)
        (fx=? r1 r2))))

  (define eqNumberImpl
    (lambda (r1)
      (lambda (r2)
        (fl=? r1 r2))))

  (define eqCharImpl
    (lambda (r1)
      (lambda (r2)
        (char=? r1 r2))))

  (define eqStringImpl
    (lambda (r1)
      (lambda (r2)
        (pstring=? r1 r2))))

  (define eqArrayImpl
    (lambda (f)
      (lambda (xs)
        (lambda (ys)
          (srfi:214:flexvector=? (lambda (x y) ((f x) y)) xs ys)))))
)
