;; -*- mode: scheme -*-

(library (Data.Functor foreign)
  (export arrayMap)
  (import (only (rnrs base) define lambda)
          (prefix (srfi :214) srfi:214:))

  (define arrayMap
    (lambda (f)
      (lambda (arr)
        (srfi:214:flexvector-map f arr))))

)
