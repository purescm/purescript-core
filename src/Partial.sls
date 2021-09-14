;; -*- mode: scheme -*-

(library (Partial foreign)
  (export _crashWith)
  (import (only (rnrs base) define lambda error))

  (define _crashWith
    (lambda (msg)
      (error #f msg)))

)
