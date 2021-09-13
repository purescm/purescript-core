;; -*- mode: scheme -*-

(library (Data.Semigroup foreign)
  (export concatString
          concatArray)
  (import (only (rnrs base) define lambda error))

  (define concatString
    (lambda (s1)
      (lambda (s2)
        (error #f "Data.Semigroup:concatString not implemented."))))

  (define concatArray
    (lambda (xs)
      (lambda (ys)
        (error #f "Data.Semigroup:concatArray not implemented."))))

)
