;; -*- mode: scheme -*-

(library (Data.Show foreign)
  (export showIntImpl
          showNumberImpl
          showCharImpl
          showStringImpl
          showArrayImpl
          cons
          join)
  (import (only (rnrs base) define lambda error))

  (define showIntImpl
    (lambda (n)
      (error #f "Data.Show:showIntImpl not implemented.")))

  (define showNumberImpl
    (lambda (n)
      (error #f "Data.Show:showNumberImpl not implemented.")))

  (define showCharImpl
    (lambda (c)
      (error #f "Data.Show:showCharImpl not implemented.")))

  (define showStringImpl
    (lambda (s)
      (error #f "Data.Show:showStringImpl not implemented.")))

  (define showArrayImpl
    (lambda (s)
      (error #f "Data.Show:showArrayImpl not implemented.")))

  (define cons
    (lambda (head)
      (lambda (tail)
        (error #f "Data.Show:cons not implemented."))))

  (define join
    (lambda (separator)
      (lambda (xs)
        (error #f "Data.Show:join not implemented."))))

)
