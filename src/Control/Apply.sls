;; -*- mode: scheme -*-

(library (Control.Apply foreign)
  (export arrayApply)
  (import (only (rnrs base) define lambda error))

  (define arrayApply
    (lambda (fs)
      (lambda (xs)
        (error #f "Control.Apply:arrayApply not implemented."))))

)
