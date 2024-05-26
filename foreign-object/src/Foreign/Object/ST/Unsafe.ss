;; -*- mode: scheme -*-

(library (Foreign.Object.ST foreign)
  (export unsafeFreeze)
  (import (only (rnrs base) define lambda))

  (define unsafeFreeze
    (lambda (m)
      (lambda ()
        m)))
)
