;; -*- mode: scheme -*-

(library (Data.Functor foreign)
  (export arrayMap)
  (import (only (rnrs base) define lambda error))

  (define arrayMap
    (lambda (f)
      (lambda (arr)
        (error #f "Data.Functor:arrayMap not implemented."))))

)
