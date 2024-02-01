;; -*- mode: scheme -*-

(library (Data.Symbol foreign)
  (export unsafeCoerce)
  (import (only (rnrs base) define lambda))

  (define unsafeCoerce
    (lambda (arg)
      arg))

)
