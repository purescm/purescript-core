;; -*- mode: scheme -*-

(library (Data.Ord foreign)
  (export ordBooleanImpl
          ordIntImpl
          ordNumberImpl
          ordStringImpl
          ordCharImpl
          ordArrayImpl)
  (import (only (rnrs base) define lambda error))

  (define ordBooleanImpl
    (lambda (lt)
      (lambda (eq)
        (lambda (gt)
          (lambda (x)
            (lambda (y)
              (error #f "Data.Ord:ordBooleanImpl not implemented.")))))))

  (define ordIntImpl
    (lambda (lt)
      (lambda (eq)
        (lambda (gt)
          (lambda (x)
            (lambda (y)
              (error #f "Data.Ord:ordIntImpl not implemented.")))))))

  (define ordNumberImpl
    (lambda (lt)
      (lambda (eq)
        (lambda (gt)
          (lambda (x)
            (lambda (y)
              (error #f "Data.Ord:ordNumberImpl not implemented.")))))))

  (define ordStringImpl
    (lambda (lt)
      (lambda (eq)
        (lambda (gt)
          (lambda (x)
            (lambda (y)
              (error #f "Data.Ord:ordStringImpl not implemented.")))))))

  (define ordCharImpl
    (lambda (lt)
      (lambda (eq)
        (lambda (gt)
          (lambda (x)
            (lambda (y)
              (error #f "Data.Ord:ordCharImpl not implemented.")))))))

  (define ordArrayImpl
    (lambda (f)
      (lambda (xs)
        (lambda (ys)
          (error #f "Data.Ord:ordArrayImpl not implemented.")))))

)
