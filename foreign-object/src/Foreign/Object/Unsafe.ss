;; -*- mode: scheme -*-

(library (Foreign.Object.Unsafe foreign)
  (export unsafeIndex)
  (import (only (rnrs base) define lambda if)
          (prefix (chezscheme) scm:)
          (prefix (purescm runtime) rt:)
          (only (purescm pstring) pstring->symbol))

  (define unsafeIndex
    (lambda (m)
      (lambda (k)
        (if (rt:record-has (scm:unbox m) (pstring->symbol k))
            (rt:record-ref (scm:unbox m) (pstring->symbol k))
            (scm:raise (scm:condition (scm:make-error) (scm:make-message-condition "unsafeIndex: key not found")))))))
)
