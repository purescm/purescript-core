;; -*- mode: scheme -*-

(library (Foreign.Object.Unsafe foreign)
  (export unsafeIndex)
  (import (only (rnrs base) define lambda if)
          (prefix (chezscheme) scm:)
          (only (purs runtime pstring) pstring->string))

  (define unsafeIndex
    (lambda (m)
      (lambda (k)
        (if (scm:hashtable-contains? m (pstring->string k))
            (scm:hashtable-ref m (pstring->string k) #f)
            (scm:raise (scm:condition (scm:make-error) (scm:make-message-condition "unsafeIndex: key not found")))))))
)
