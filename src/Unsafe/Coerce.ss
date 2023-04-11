;; -*- mode: scheme -*-

(library (Unsafe.Coerce foreign)
  (export unsafeCoerce)
  (import (only (rnrs base) define lambda))

  (define unsafeCoerce
    (lambda (x)
      x))

)
