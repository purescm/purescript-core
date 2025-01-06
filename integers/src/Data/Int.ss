;; -*- mode: scheme -*-

(library (Data.Int foreign)
  (export fromNumberImpl
          toNumber
          fromStringAsImpl
          toStringAs
          quot
          rem
          pow)
  (import (only (rnrs base) define lambda if let cond else call-with-current-continuation)
          (only (rnrs arithmetic flonums) fixnum->flonum fltruncate fl=?)
          (only (chezscheme) format flonum->fixnum fixnum? fx=? fx/ fxremainder expt
                             with-exception-handler string-append number->string string->number)
          (only (purescm pstring) pstring->string string->pstring))

  (define fromNumberImpl
    (lambda (just)
      (lambda (nothing)
        (lambda (n)
          (call-with-current-continuation
            (lambda (k)
              (with-exception-handler
                (lambda (e) (k nothing))
                  (lambda ()
                    (if (fl=? (fltruncate n) n)
                      (just (flonum->fixnum n))
                      nothing)))))))))

  (define toNumber
    (lambda (n)
      (fixnum->flonum n)))

  (define fromStringAsImpl
    (lambda (just)
      (lambda (nothing)
        (lambda (radix)
          (lambda (s)
            (let ([res (string->number (string-append "#" (number->string radix) "r" (pstring->string s)))])
              (if (fixnum? res)
                (just res)
                nothing)))))))

  ;; TODO we only support a fixed set of radices here
  (define toStringAs
    (lambda (radix)
      (lambda (i)
        (string->pstring
          (cond
            [(fx=? radix 2) (format "~b" i)]
            [(fx=? radix 8) (format "~o" i)]
            [(fx=? radix 10) (format "~d" i)]
            [(fx=? radix 16) (format "~x" i)]
            ;; Fall back to decimal
            [else (format "~d" i)])))))

  (define quot
    (lambda (x)
      (lambda (y)
        (fx/ x y))))

  (define rem
    (lambda (x)
      (lambda (y)
        (fxremainder x y))))

  (define pow
    (lambda (x)
      (lambda (y)
        (let ([res (expt x y)])
          (if (fixnum? res) res 0)))))

)
