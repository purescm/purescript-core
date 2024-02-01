;; -*- mode: scheme -*-

(library (Effect.Unsafe foreign)
  (export unsafePerformEffect)
  (import (only (rnrs base) define lambda))

  (define unsafePerformEffect
    (lambda (f)
      (f)))

)
