;; -*- mode: scheme -*-

(library (Data.FunctorWithIndex foreign)
  (export mapWithIndexArray)
  (import (only (rnrs base) define lambda)
          (prefix (srfi :214) srfi:214:))
          
  (define mapWithIndexArray
    (lambda (f)
      (lambda (xs)
        (srfi:214:flexvector-map/index (lambda (i x) ((f i) x)) xs))))

)
