;; -*- mode: scheme -*-

(library (Data.Semigroup foreign)
  (export concatString
          concatArray)
  (import (only (rnrs base) define lambda)
          (only (purescm pstring) pstring-concat)
          (prefix (srfi :214) srfi:214:))

  (define concatString
    (lambda (s1)
      (lambda (s2)
        (pstring-concat s1 s2))))

  (define concatArray
    (lambda (xs)
      (lambda (ys)
        (srfi:214:flexvector-append xs ys))))

)
