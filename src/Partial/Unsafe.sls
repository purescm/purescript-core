;; -*- mode: scheme -*-

(library (Partial.Unsafe foreign)
  (export _unsafePartial)
  (import (only (rnrs base) define lambda))

  (define _unsafePartial
    (lambda (f)
      (f)))

)
