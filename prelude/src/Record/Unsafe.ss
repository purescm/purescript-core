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
        (rt:record-has rec (string->symbol label)))))

  (define unsafeGet
    (lambda (label)
      (lambda (rec)
        (rt:record-ref rec (string->symbol label)))))

  (define unsafeSet
    (lambda (label)
      (lambda (value)
        (lambda (rec)
          (rt:record-set rec (string->symbol label) value)))))

  (define unsafeDelete
    (lambda (label)
      (lambda (rec)
        (rt:record-remove rec (string->symbol label)))))

)
