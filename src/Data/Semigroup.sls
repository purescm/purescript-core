;; -*- mode: scheme -*-

(library (Data.Semigroup foreign)
  (export concatString
          concatArray)
  (import (only (rnrs base) define lambda error string-append))

  (define concatString
    (lambda (s1)
      (lambda (s2)
        (string-append s1 s2))))

  (define concatArray
    (lambda (xs)
      (lambda (ys)
        (error #f "Data.Semigroup:concatArray not implemented."))))

)
