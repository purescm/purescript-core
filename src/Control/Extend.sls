;; -*- mode: scheme -*-

(library (Control.Extend foreign)
  (export arrayExtend)
  (import (only (rnrs base) define lambda error))

  (define arrayExtend
    (lambda (f)
      (lambda (xs)
        (error #f "Control.Extend:arrayExtend not implemented."))))

)
