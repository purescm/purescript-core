;; -*- mode: scheme -*-

(library (Data.Semigroup foreign)
  (export concatString
          concatArray)
  (import (only (rnrs base) define lambda string-append)
          (prefix (purs runtime srfi :214) srfi:214:))

  (define concatString
    (lambda (s1)
      (lambda (s2)
        (string-append s1 s2))))

  (define concatArray
    (lambda (xs)
      (lambda (ys)
        (srfi:214:flexvector-append xs ys))))

)
