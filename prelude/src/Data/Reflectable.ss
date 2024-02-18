;; -*- mode: scheme -*-

(library (Data.Reflectable foreign)
  (export unsafeCoerce)
  (import (only (rnrs base) define lambda))

  (define unsafeCoerce
    (lambda (x)
      x))
)
