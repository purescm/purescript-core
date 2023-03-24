;; -*- mode: scheme -*-

(library (Data.Show foreign)
  (export showIntImpl
          showNumberImpl
          showCharImpl
          showStringImpl
          showArrayImpl
          cons
          join)
  (import (only (rnrs base) define lambda let* quote begin if set!
                            + - < >=
                            error number->string string-append
                            vector-ref vector-length)
          (only (rnrs control) do))

  (define showIntImpl
    (lambda (n)
      (number->string n)))

  (define showNumberImpl
    (lambda (n)
      (number->string n)))

  (define showCharImpl
    (lambda (c)
      (error #f "Data.Show:showCharImpl not implemented.")))

  (define showStringImpl
    (lambda (s)
      (error #f "Data.Show:showStringImpl not implemented.")))

  (define showArrayImpl
    (lambda (f)
      (lambda (xs)
        (let* ([buffer  "["]
               [append! (lambda (str) (set! buffer (string-append buffer str)))])
          (do ([i 0 (+ i 1)])
              ((>= i (vector-length xs)) '())
            (begin 
              (append! (f (vector-ref xs i)))
              (if (< i (- (vector-length xs) 1))
                  (append! ","))))
          (append! "]")
          buffer))))

  (define cons
    (lambda (head)
      (lambda (tail)
        (error #f "Data.Show:cons not implemented."))))

  (define join
    (lambda (separator)
      (lambda (xs)
        (error #f "Data.Show:join not implemented."))))

)
