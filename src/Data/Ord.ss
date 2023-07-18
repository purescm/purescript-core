;; -*- mode: scheme -*-

(library (Data.Ord foreign)
  (export ordBooleanImpl
          ordIntImpl
          ordNumberImpl
          ordStringImpl
          ordCharImpl
          ordArrayImpl)
  (import (chezscheme))
  (import (only (rnrs base) define lambda)
          (prefix (purs runtime srfi :214) srfi:214:))

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
              (if (< x y)
                  lt
                  (if (= x y) eq gt))))))))

  (define ordNumberImpl
    (lambda (lt)
      (lambda (eq)
        (lambda (gt)
          (lambda (x)
            (lambda (y)
              (if (< x y)
                  lt
                  (if (= x y) eq gt))))))))

  (define ordStringImpl
    (lambda (lt)
      (lambda (eq)
        (lambda (gt)
          (lambda (x)
            (lambda (y)
              (if (string<? x y)
                  lt
                  (if (string=? x y) eq gt))))))))

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
             (let loop ([xsi 0] [ysi 0])
               (cond
                 [(or (= xsi xlen) (= ysi ylen))
                    (cond
                      [(= xlen ylen) 0]
                      [(> xlen ylen) -1]
                      (else 1))]
                 [else
                   (let ([o ((f (srfi:214:flexvector-ref xs xsi)) (srfi:214:flexvector-ref ys ysi))])
                     (if (not (fx=? o 0))
                       o
                       (loop
                         (+ xsi 1)
                         (+ ysi 1))))])))))))
)
