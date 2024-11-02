;; -*- mode: scheme -*-

(library (Data.Ord foreign)
  (export ordBooleanImpl
          ordIntImpl
          ordNumberImpl
          ordStringImpl
          ordCharImpl
          ordArrayImpl)
  (import (chezscheme)
          (only (purescm pstring) pstring<? pstring=?)
          (prefix (srfi :214) srfi:214:))

  (define ordBooleanImpl
    (lambda (lt)
      (lambda (eq)
        (lambda (gt)
          (lambda (x)
            (lambda (y)
              (if (and (not x) y)
                  lt
                  (if (eq? x y) eq gt))))))))

  (define ordIntImpl
    (lambda (lt)
      (lambda (eq)
        (lambda (gt)
          (lambda (x)
            (lambda (y)
              (if (fx<? x y)
                  lt
                  (if (fx=? x y) eq gt))))))))

  (define ordNumberImpl
    (lambda (lt)
      (lambda (eq)
        (lambda (gt)
          (lambda (x)
            (lambda (y)
              (if (fl<? x y)
                  lt
                  (if (fl=? x y) eq gt))))))))

  (define ordStringImpl
    (lambda (lt)
      (lambda (eq)
        (lambda (gt)
          (lambda (x)
            (lambda (y)
              (if (pstring<? x y)
                  lt
                  (if (pstring=? x y) eq gt))))))))

  (define ordCharImpl
    (lambda (lt)
      (lambda (eq)
        (lambda (gt)
          (lambda (x)
            (lambda (y)
              (if (char<? x y)
                  lt
                  (if (char=? x y) eq gt))))))))

  (define ordArrayImpl
    (lambda (f)
      (lambda (xs)
        (lambda (ys)
          (let ([xlen (srfi:214:flexvector-length xs)]
                [ylen (srfi:214:flexvector-length ys)])
             (let loop ([xsi 0]
                        [ysi 0])
               (if (or (fx=? xsi xlen) (fx=? ysi ylen))
                 (cond
                   [(fx=? xlen ylen) 0]
                   [(fx>? xlen ylen) -1]
                   (else 1))
                 (let ([o ((f (srfi:214:flexvector-ref xs xsi)) (srfi:214:flexvector-ref ys ysi))])
                   (if (not (fx=? o 0))
                     o
                     (loop
                       (fx1+ xsi)
                       (fx1+ ysi)))))))))))
)
