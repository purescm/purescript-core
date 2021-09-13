;; -*- mode: scheme -*-

(library (Control.Bind foreign)
  (export arrayBind)
  (import (only (rnrs base) define lambda error))

  (define arrayBind
    (lambda (arr)
      (lambda (f)
        (error #f "Control.Bind:arrayBind not implemented."))))

)
