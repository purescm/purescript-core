;; -*- mode: scheme -*-

(library (Record.Unsafe foreign)
  (export unsafeHas
          unsafeGet
          unsafeSet
          unsafeDelete)
  (import (chezscheme)
          (prefix (purs runtime) rt:))

  (define unsafeHas
    (lambda (label)
      (lambda (rec)
        (symbol-hashtable-contains? rec (string->symbol label)))))

  (define unsafeGet
    (lambda (label)
      (lambda (rec)
        (rt:object-ref rec (string->symbol label)))))

  (define unsafeSet
    (lambda (label)
      (lambda (value)
        (lambda (rec)
          (let ([rec-copy (rt:object-copy rec)])
            (rt:object-set! rec-copy (string->symbol label) value)
            rec-copy)))))

  (define unsafeDelete
    (lambda (label)
      (lambda (rec)
        (let ([rec-copy (rt:object-copy rec)])
          (symbol-hashtable-delete! rec-copy (string->symbol label))
          rec-copy))))

)
