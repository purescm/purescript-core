;; -*- mode: scheme -*-

(library (Data.Show foreign)
  (export showIntImpl
          showNumberImpl
          showCharImpl
          showStringImpl
          showArrayImpl)
  (import (chezscheme)
          (prefix (purescm runtime) rt:)
          (only (purescm pstring) pstring
                                          number->pstring
                                          string->pstring
                                          pstring-uncons-char
                                          pstring->string
                                          pstring-concat
                                          pstring-make-regex
                                          pstring-regex-replace-by)
          (prefix (srfi :214) srfi:214:))

  (define showIntImpl
    (lambda (n)
      (number->pstring n)))

  (define showNumberImpl
    (lambda (n)
      (number->pstring n)))

  (define showCharImpl
    (lambda (c)
      (string->pstring (format "~s" c))))

  (define showStringImpl
    (lambda (s)
      (let ([regex (pstring-make-regex (string->pstring "[\\x00-\\x1F\\x7F\"]") (list (cons 'global #t)))]
            [replacement (lambda (match _)
                           (let-values ([(c _) (pstring-uncons-char match)])
                             (cond
                               [(char=? c #\") (pstring #\\ c)]
                               [(char=? c #\\) (pstring #\\ c)]
                               [(char=? c #\alarm) (pstring #\\ #\a)]
                               [(char=? c #\backspace) (pstring #\\ #\b)]
                               [(char=? c #\page) (pstring #\\ #\f)]
                               [(char=? c #\newline) (pstring #\\ #\n)]
                               [(char=? c #\return) (pstring #\\ #\r)]
                               [(char=? c #\tab) (pstring #\\ #\t)]
                               [(char=? c #\vtab) (pstring #\\ #\v)]
                               [else (pstring c)])))])
        (pstring-concat
          (pstring #\")
          (pstring-regex-replace-by regex s replacement)
          (pstring #\")))))

  (define (string-join xs separator)
    (let ([len (rt:array-length xs)])
      (cond
        [(fx=? len 0) (string->pstring "")]
        [(fx=? len 1) (rt:array-ref xs 0)]
        (else
          (let recur ([i 1]
                      [buffer (rt:array-ref xs 0)])
            (if (fx=? len i)
              buffer
              (recur (fx1+ i) (pstring-concat buffer separator (rt:array-ref xs i)))))))))

  (define showArrayImpl
    (lambda (f)
      (lambda (xs)
        (pstring-concat
          (pstring #\[)
          (string-join (srfi:214:flexvector-map f xs) (string->pstring ","))
          (pstring #\])))))
)
