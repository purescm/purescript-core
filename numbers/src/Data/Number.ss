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
  (import (only (rnrs base) define lambda nan? finite? cond else let and or not number? if)
          (only (chezscheme) flabs flacos flasin flatan flceiling flcos flexp flpositive?
                             flfloor fllog flmax flmin flexpt flmod flround fl-
                             fl= fl< flsin flsqrt fltan fltruncate flonum? fixnum? fixnum->flonum)
          (only (purescm pstring) pstring->number))

  (define nan +nan.0)

  (define isNaN nan?)

  (define infinity +inf.0)

  (define isFinite finite?)

  (define fromStringImpl
    (lambda (str isFinite just nothing)
      (let ([num (pstring->number str)])
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

  ;; This is one of those places where the PureScript behaviour is specced as
  ;; "whatever JavaScript does" and requires a bit of care.
  ;;
  ;; From https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Remainder:
  ;; > The remainder (%) operator returns the remainder left over when one operand
  ;; > is divided by a second operand. It always takes the sign of the dividend.
  ;;
  ;; Chez specs these a little differently (see https://scheme.com/tspl4/objects.html#./objects:s100):
  ;; - there's `mod`, where "the value xm of (mod x1 x2) is a real number such that x1 = nd · x2 + xm and 0 ≤ xm < |x2|"
  ;; - and `mod0`, where "the value xm of (mod0 x1 x2) is a real number such that x1 = nd · x2 + xm and -|x2/2| ≤ xm < |x2/2|"
  ;;
  ;; In practice we can use `flmod` and just flip the sign whenever the dividend is negative.
  (define remainder
    (lambda (n)
      (lambda (m)
        (if (flpositive? n)
            (flmod n m)
            (fl- (flmod (fl- n) m))))))

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
