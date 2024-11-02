;; -*- mode: scheme -*-

(library (Record.Unsafe foreign)
  (export unsafeHas
          unsafeGet
          unsafeSet
          unsafeDelete)
  (import (chezscheme)
          (only (purescm pstring) pstring->symbol)
          (prefix (purescm runtime) rt:))

  (define unsafeHas
    (lambda (label)
      (lambda (rec)
        (rt:record-has rec (pstring->symbol label)))))

  (define unsafeGet
    (lambda (label)
      (lambda (rec)
        (rt:record-ref rec (pstring->symbol label)))))

  (define unsafeSet
    (lambda (label)
      (lambda (value)
        (lambda (rec)
          (rt:record-set rec (pstring->symbol label) value)))))

  (define unsafeDelete
    (lambda (label)
      (lambda (rec)
        (rt:record-remove rec (pstring->symbol label)))))

)
