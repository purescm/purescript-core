;; -*- mode: scheme -*-

(library (Record.Unsafe foreign)
  (export unsafeHas
          unsafeGet
          unsafeSet
          unsafeDelete)
  (import (only (rnrs base) define lambda let)
          (prefix (purs runtime) rt:)
          (prefix (purs runtime srfi :125) srfi:125:))

  (define unsafeHas
    (lambda (label)
      (lambda (rec)
        (srfi:125:hash-table-contains? rec label))))

  (define unsafeGet
    (lambda (label)
      (lambda (rec)
        (rt:object-ref rec label))))

  (define unsafeSet
    (lambda (label)
      (lambda (value)
        (lambda (rec)
          (let ([rec-copy (rt:object-copy rec)])
            (rt:object-set! rec-copy label value)
            rec-copy)))))

  (define unsafeDelete
    (lambda (label)
      (lambda (rec)
        (let ([rec-copy (rt:object-copy rec)])
          (srfi:125:hash-table-delete! rec-copy label)
          rec-copy))))

)
