;; -*- mode: scheme -*-

(library (Partial foreign)
  (export _crashWith)
  (import (only (rnrs base) define lambda error)
          (only (purescm pstring) pstring->string))

  (define _crashWith
    (lambda (msg)
      (error #f (pstring->string msg))))

)
