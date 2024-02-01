;; -*- mode: scheme -*-

(library (Data.Show foreign)
  (export showIntImpl
          showNumberImpl
          showCharImpl
          showStringImpl
          showArrayImpl
          cons
          join)
  (import (only (rnrs base) define lambda let + = cond else if 
                            string number->string string-append)
          (only (chezscheme) format)
          (prefix (purs runtime) rt:)
          (prefix (purs runtime srfi :214) srfi:214:))

  (define showIntImpl
    (lambda (n)
      (number->string n)))

  (define showNumberImpl
    (lambda (n)
      (number->string n)))

  (define showCharImpl
    (lambda (c)
      (format "~s" c)))

  (define showStringImpl
    (lambda (s)
      (format "~s" s)))

  (define (string-join xs separator)
    (let ([len (rt:array-length xs)])
      (cond
        [(= len 0) ""]
        [(= len 1) (rt:array-ref xs 0)]
        (else
          (let recur ([i 1]
                      [buffer (rt:array-ref xs 0)])
            (if (= len i)
              buffer
              (recur (+ i 1) (string-append buffer separator (rt:array-ref xs i)))))))))

  (define showArrayImpl
    (lambda (f)
      (lambda (xs)
        (string-append "[" (string-join (srfi:214:flexvector-map f xs) ",") "]"))))

  (define cons
    (lambda (head)
      (lambda (tail)
        (srfi:214:flexvector-append (rt:make-array head) tail))))

  (define join
    (lambda (separator)
      (lambda (xs)
        (string-join xs separator))))

)
