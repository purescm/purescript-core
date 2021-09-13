;; -*- mode: scheme -*-

(library (Data.Symbol foreign)
  (export unsafeCoerce)
  (import (only (rnrs base) define lambda error))

  (define unsafeCoerce
    (lambda (arg)
      (error #f "Data.Symbol:unsafeCoerce not implemented.")))

)
