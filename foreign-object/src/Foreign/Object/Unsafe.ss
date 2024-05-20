;; -*- mode: scheme -*-

(library (Foreign.Object.Unsafe foreign)
  (export unsafeIndex)
  (import (only (rnrs base) define lambda if)
          (prefix (chezscheme) scm:)
          (only (purs runtime pstring) pstring->symbol))

  (define unsafeIndex
    (lambda (m)
      (lambda (k)
        (if (scm:symbol-hashtable-contains? (scm:car m) (pstring->symbol k))
            (scm:symbol-hashtable-ref (scm:car m) (pstring->symbol k) #f)
            (scm:raise (scm:condition (scm:make-error) (scm:make-message-condition "unsafeIndex: key not found")))))))
)
