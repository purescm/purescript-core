;; -*- mode: scheme -*-

(library (Foreign.Object.ST foreign)
  (export new
          peekImpl
          poke
          delete)
  (import (only (rnrs base) define lambda if let)
          (prefix (chezscheme) scm:)
          (prefix (purs runtime) rt:)
          (only (purs runtime pstring) pstring->symbol))

  (define remove-1st
    (lambda (x ls)
      (if (scm:null? ls)                 ; If an empty list
        (scm:quote ())                   ; Return an empty list
        (if (scm:equal? x (scm:car ls))  ; Otherwise, if first item in list
          (scm:cdr ls)                   ; Return rest of list, done
          (scm:cons (scm:car ls) (remove-1st x (scm:cdr ls)))))))
          ; Otherwise, cons first item and
          ; rest of list with our item removed


  (define new
    (lambda ()
      (scm:cons
        (scm:make-hashtable scm:symbol-hash scm:symbol=? 32)
        (scm:quote ()))))

  (define peekImpl
    (lambda (just)
      (lambda (nothing)
        (lambda (k)
          (lambda (m)
            (lambda ()
              (if (scm:symbol-hashtable-contains? (scm:car m) (pstring->symbol k))
                  (just (scm:symbol-hashtable-ref (scm:car m) (pstring->symbol k) #f))
                  nothing)))))))

  (define poke
    (lambda (k)
      (lambda (v)
        (lambda (m)
          (lambda ()
            (scm:symbol-hashtable-set! (scm:car m) (pstring->symbol k) v)
            (scm:set-cdr! m (scm:cons (pstring->symbol k) (scm:cdr m)))
            m)))))

  (define delete
    (lambda (k)
      (lambda (m)
        (lambda ()
          (scm:symbol-hashtable-delete! (scm:car m) (pstring->symbol k))
          (scm:set-cdr! m (remove-1st (pstring->symbol k) (scm:cdr m)))
          m))))
)
