;; -*- mode: scheme -*-

(library (Foreign.Object.ST foreign)
  (export new
          peekImpl
          poke
          delete)
  (import (only (rnrs base) define lambda if)
          (prefix (chezscheme) scm:)
          (only (purs runtime pstring) pstring->string))

  (define new
    (lambda ()
      (scm:make-hashtable scm:string-hash scm:string=?)))

  (define peekImpl
    (lambda (just)
      (lambda (nothing)
        (lambda (k)
          (lambda (m)
            (lambda ()
              (if (scm:hashtable-contains? m (pstring->string k))
                  (just (scm:hashtable-ref m (pstring->string k) #f))
                  nothing)))))))

  (define poke
    (lambda (k)
      (lambda (v)
        (lambda (m)
          (lambda ()
            (scm:hashtable-set! m (pstring->string k) v)
            m)))))

  (define delete
    (lambda (k)
      (lambda (m)
        (lambda ()
          (scm:hashtable-delete! m (pstring->string k))
          m))))
)
