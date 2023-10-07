;; -*- mode: scheme -*-

(library (Data.Number foreign)
  (export nan
          isNaN
          infinity
          isFinite
          fromStringImpl
          abs
          acos
          asin
          atan
          atan2
          ceil
          cos
          exp
          floor
          log
          max
          min
          pow
          remainder
          round
          sign
          sin
          sqrt
          tan
          trunc
          )
  (import (only (rnrs base) define lambda nan? finite? cond else let and or not string->number number?)
          (only (chezscheme) flabs flacos flasin flatan flceiling flcos flexp
                             flfloor fllog flmax flmin flexpt flmod0 flround
                             fl= fl< flsin flsqrt fltan fltruncate flonum? fixnum? fixnum->flonum))

  (define nan +nan.0)

  (define isNaN nan?)

  (define infinity +inf.0)

  (define isFinite finite?)

  (define fromStringImpl
    (lambda (str isFinite just nothing)
      (let ([num (string->number str)])
        (cond
          [(or (not (number? num)) (not (isFinite num))) nothing]
          [(fixnum? num) (just (fixnum->flonum num))] 
          [(flonum? num) (just num)]
          [else nothing]))))

  (define abs flabs)

  (define acos flacos)

  (define asin flasin)

  (define atan flatan)

  (define atan2
    (lambda (y)
      (lambda (x)
        (flatan y x))))

  (define ceil flceiling)

  (define cos flcos)

  (define exp flexp)

  (define floor flfloor)

  (define log fllog)

  (define max
    (lambda (n1)
      (lambda (n2)
        (flmax n1 n2))))

  (define min
    (lambda (n1)
      (lambda (n2)
        (flmin n1 n2))))

  (define pow
    (lambda (n)
      (lambda (p)
        (flexpt n p))))

  (define remainder
    (lambda (n)
      (lambda (m)
        (flmod0 n m))))

  (define round flround)

  (define sign
    (lambda (x)
      (cond
        [(fl= x 0.0) x]
        [(nan? x) x]
        [(fl< x 0.0) -1.0]
        [else 1.0])))

  (define sin flsin)

  (define sqrt flsqrt)

  (define tan fltan)

  (define trunc fltruncate)

)
