;; -*- mode: scheme -*-

(library (Record.Unsafe foreign)
  (export unsafeHas
          unsafeGet
          unsafeSet
          unsafeDelete)
  (import (only (rnrs base) define lambda error))

  (define unsafeHas
    (lambda (label)
      (lambda (rec)
        (error #f "Record.Unsafe:unsafeHas not implemented."))))

  (define unsafeGet
    (lambda (label)
      (lambda (rec)
        (error #f "Record.Unsafe:unsafeGet not implemented."))))

  (define unsafeSet
    (lambda (label)
      (lambda (rec)
        (error #f "Record.Unsafe:unsafeSet not implemented."))))

  (define unsafeDelete
    (lambda (label)
      (lambda (rec)
        (error #f "Record.Unsafe:unsafeDelete not implemented."))))

)
