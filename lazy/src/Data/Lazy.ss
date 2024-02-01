;; -*- mode: scheme -*-

(library (Data.Lazy foreign)
  (export defer
          force
  )

  (import (only (rnrs base) define lambda quote))

  (define defer
    (lambda (thunk)
      (lambda ()
        (thunk 'unit))))

  (define force
    (lambda (thunk) (thunk)))
)
