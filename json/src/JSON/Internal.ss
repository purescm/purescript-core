(library (JSON.Internal foreign)
  (export _parse
          _fromNumberWithDefault
          _case
          toArray
          fromArray
          _fromEntries
          _insert
          _delete
          _entries
          _lookup
          empty
          length
          _index
          _append
          isNull

          ; Exported for testing
          json-parse
          json-stringify)
  (import (except (chezscheme) length)
          (prefix (srfi :214) srfi:214:)
          (purescm pstring))

  (define (_parse left right s)
    (call/cc
      (lambda (k)
        (with-exception-handler
          (lambda (e) (left (k (string->pstring (condition-message e)))))
          (lambda () (right (json-parse s)))))))

  (define (_fromNumberWithDefault fallback n)
    (if (or (nan? n) (not (finite? n)))
      fallback
      n))

  (define (_case isNull isBool isNum isStr isArr isObj j)
    (cond
      [(pstring? j) (isStr j)]
      [(eq? 'null j) (isNull j)]
      [(boolean? j) (isBool j)]
      [(number? j) (isNum (inexact j))]
      [(srfi:214:flexvector? j) (isArr j)]
      [(list? j) (isObj j)]
      [else (error #f "Value is not JSON")]))

  (define (toArray v) v)

  (define (fromArray v) v)

  (define (_fromEntries fst snd entries)
    (srfi:214:flexvector-fold (lambda (tail entry)
                                (cons (cons (pstring->symbol (fst entry)) (snd entry)) tail))
                              '()
                              entries))

  (define (_insert k v obj)
    (cons (cons k v) (_delete k obj)))

  (define (_delete k obj)
    (if (null? obj)
      obj
      (if (eq? (caar obj) k)
        (cdr obj)
        (cons (car obj) (_delete k (cdr obj))))))

  (define (_entries tuple obj)
    (srfi:214:list->flexvector (map (lambda (entry)
                                      ((tuple (symbol->pstring (car entry))) (cdr entry)))
                                    obj)))

  (define (_lookup nothing just key obj)
    (let ([res (assq (pstring->symbol key) obj)])
      (if (not res)
        nothing
        (just (cdr res)))))

  (define empty (srfi:214:flexvector))

  (define length srfi:214:flexvector-length)

  (define (_index nothing just ix arr)
    (if (and (fx>=? ix 0) (fx<? ix (srfi:214:flexvector-length arr)))
      (just (srfi:214:flexvector-ref arr ix))
      nothing))

  (define _append srfi:214:flexvector-append)

  (define (isNull j) (eq? j 'null))


  ; ---------------------------------------------------
  ; JSON parser
  ; ---------------------------------------------------

  (define true (string->pstring "true"))
  (define false (string->pstring "false"))
  (define null (string->pstring "null"))

  (define (expect-char cur expected)
    (let ([ch (pstring-cursor-read-char cur)])
      (when (not (eqv? ch expected))
        (error #f (format "Unexpected '~a', was expecting '~a'" ch expected)))))

  (define (json-parse str)
    (let* ([cur (pstring->cursor str)]
           [res (read-json-value cur)])
      ; Do not allow trailing tokens after we've succesfully parsed a json value
      (skip-whitespace cur)
      (let ([ch (pstring-cursor-peek-char cur)])
        (if (not (eof-object? ch))
          (error #f (format "Unexpected token '~a'" ch))
          res))))

  ; The basic expression parser
  (define (read-json-value cur)
    (skip-whitespace cur)
    (let ([ch (pstring-cursor-peek-char cur)])
      (cond
        [(eqv? ch #\t)
         (begin
           (pstring-cursor-read-char cur)
           (expect-char cur #\r)
           (expect-char cur #\u)
           (expect-char cur #\e)
           #t)]
        [(eqv? ch #\f)
         (begin
           (pstring-cursor-read-char cur)
           (expect-char cur #\a)
           (expect-char cur #\l)
           (expect-char cur #\s)
           (expect-char cur #\e)
           #f)]
        [(eqv? ch #\n)
         (begin
           (pstring-cursor-read-char cur)
           (expect-char cur #\u)
           (expect-char cur #\l)
           (expect-char cur #\l)
           'null)]
        [(eqv? ch #\") (read-json-string cur)]
        [(eqv? ch #\[) (read-json-array cur)]
        [(eqv? ch #\{) (read-json-object cur)]
        [(eqv? ch #\-) (begin
                         (pstring-cursor-read-char cur)
                         (* -1 (read-json-number cur)))]
        [(char<=? #\0 ch #\9) (read-json-number cur)]
        [else (error #f (format "Unexpected token '~a'" ch))])))

  (define (read-unicode-escape cur)
    (define (read-hex-digit cur)
      (let ([ch (pstring-cursor-read-char cur)])
        (cond
          [(eqv? ch #\0) 0]
          [(eqv? ch #\1) 1]
          [(eqv? ch #\2) 2]
          [(eqv? ch #\3) 3]
          [(eqv? ch #\4) 4]
          [(eqv? ch #\5) 5]
          [(eqv? ch #\6) 6]
          [(eqv? ch #\7) 7]
          [(eqv? ch #\8) 8]
          [(eqv? ch #\9) 9]
          [(or (eqv? ch #\A) (eqv? ch #\a)) 10]
          [(or (eqv? ch #\B) (eqv? ch #\b)) 11]
          [(or (eqv? ch #\C) (eqv? ch #\c)) 12]
          [(or (eqv? ch #\D) (eqv? ch #\d)) 13]
          [(or (eqv? ch #\E) (eqv? ch #\e)) 14]
          [(or (eqv? ch #\F) (eqv? ch #\f)) 15]
          [(eof-object? ch) (error #f "Unexpected end of input, was expecting a hex digit")]
          [else (error #f (format "Unexpected token '~a', was expecting a hex digit" ch))])))

    (let* ([first (read-hex-digit cur)]
           [second (read-hex-digit cur)]
           [third (read-hex-digit cur)]
           [fourth (read-hex-digit cur)])
      (+ (* 4096 first)
         (* 256 second)
         (* 16 third)
         fourth)))

  (define (read-unicode-code-point cur)
    (let ([w1 (read-unicode-escape cur)])
      (cond
        ; If it's a two-word encoded value we need to read a second escape
        [(fx<= #xD800 w1 #xDBFF)
          (let* ([_ (expect-char cur #\\)]
                 [_ (expect-char cur #\u)]
                 [w2 (read-unicode-escape cur)])
            (if (fx<= #xDC00 w2 #xDFFF)
              (fx+
                (fxlogor
                  (fxsll (fx- w1 #xD800) 10)
                  (fx- w2 #xDC00))
                #x10000)
              (error #f (format "Invalid unicode surrogate pair ~,x ~,x" w1 w2))))]
        [(fx<= #xDC00 w1 #xDFFF)
          (error #f (format "Invalid unicode escape ~,x" w1))]
        [else w1])))

  (define (read-escape cur)
    (let ([ch (pstring-cursor-read-char cur)])
      (cond
        [(eqv? ch #\") (pstring #\")]
        [(eqv? ch #\\) (pstring #\\)]
        [(eqv? ch #\/) (pstring #\/)]
        [(eqv? ch #\b) (pstring #\backspace)]
        [(eqv? ch #\f) (pstring #\page)]
        [(eqv? ch #\n) (pstring #\newline)]
        [(eqv? ch #\r) (pstring #\return)]
        [(eqv? ch #\t) (pstring #\tab)]
        [(eqv? ch #\u) (code-points->pstring (read-unicode-code-point cur))]
        [else (error #f (format "Invalid string escape ~a" ch))])))

  (define (control-char? ch)
    (fx<= (char->integer ch) #x1f))

  (define (read-json-string cur)
    (expect-char cur #\")
    (let loop ([start (cursor->pstring cur)] [i 0] [parts '()])
      (let ([ch (pstring-cursor-read-char cur)])
        (cond
          [(eqv? ch #\") (apply pstring-concat (reverse (cons (pstring-take start i) parts)))]
          [(control-char? ch) (error #f "Invalid control character in string")]
          [(eqv? ch #\\)
           (let ([e (read-escape cur)])
            (loop (cursor->pstring cur)
                  0
                  (cons e (cons (pstring-take start i) parts))))]
          [else (loop start (fx1+ i) parts)]))))

  (define (read-digit cur)
    (let ([ch (pstring-cursor-read-char cur)])
      (cond
        [(eqv? ch #\0) 0]
        [(eqv? ch #\1) 1]
        [(eqv? ch #\2) 2]
        [(eqv? ch #\3) 3]
        [(eqv? ch #\4) 4]
        [(eqv? ch #\5) 5]
        [(eqv? ch #\6) 6]
        [(eqv? ch #\7) 7]
        [(eqv? ch #\8) 8]
        [(eqv? ch #\9) 9])))

  (define (read-int cur)
    (let loop ([n 0])
      (let ([ch (pstring-cursor-peek-char cur)])
        (cond
          [(eof-object? ch) n]
          [(char<=? #\0 ch #\9) (loop (+ (* n 10) (read-digit cur)))]
          [else n]))))

  (define (read-number-fraction cur)
    (let ([ch (pstring-cursor-peek-char cur)])
      (if (eqv? ch #\.)
        (begin
          (pstring-cursor-read-char cur)
          (let loop ([n 0] [len 0])
            (let ([ch (pstring-cursor-peek-char cur)])
              (cond
                [(and (char? ch) (char<=? #\0 ch #\9)) (loop (+ (* n 10) (read-digit cur)) (fx1+ len))]
                [(fx=? len 0) (error #f "Unexpected end of number, was expecting a fraction")]
                [else (/ n (expt 10 len))]))))
        0)))

  (define (read-number-exponent cur)
    (define (read-sign cur)
      (let ([ch (pstring-cursor-peek-char cur)])
        (cond
          [(eqv? ch #\+) (begin (pstring-cursor-read-char cur) 1)]
          [(eqv? ch #\-) (begin (pstring-cursor-read-char cur) -1)]
          [else 1])))

    (let ([ch (pstring-cursor-peek-char cur)])
      (if (or (eqv? ch #\e) (eqv? ch #\E))
        (let* ([_ (pstring-cursor-read-char cur)]
               [sign (read-sign cur)]
               [digits (read-int cur)])
          (expt 10 (* sign digits)))
        1)))

  (define (read-json-number cur)
    (let ([ch (pstring-cursor-peek-char cur)])
      (cond
        [(eqv? ch #\0)
         (begin
           (pstring-cursor-read-char cur)
           (read-number-fraction cur))]
        [else
         (let* ([num (read-int cur)]
                [fraction (read-number-fraction cur)]
                [exponent (read-number-exponent cur)])
           (* (+ num fraction) exponent))])))

  (define (read-json-array cur)
    (expect-char cur #\[)
    (let loop ([items '()])
      (skip-whitespace cur)
      (let ([ch (pstring-cursor-peek-char cur)])
        (cond
          [(eqv? ch #\]) (begin
                           (pstring-cursor-read-char cur)
                           (srfi:214:list->flexvector (reverse items)))]
          [(null? items) (loop (cons (read-json-value cur) items))]
          [(eqv? ch #\,) (pstring-cursor-read-char cur)
                         (loop (cons (read-json-value cur) items))]
          [else (error #f (format "Unexpected token '~a'" ch))]))))

  (define (read-json-object cur)
    (define (read-object-pair cur)
      (skip-whitespace cur)
      (let ([key (read-json-string cur)])
        (skip-whitespace cur)
        (expect-char cur #\:)
        (cons (pstring->symbol key) (read-json-value cur))))

    (expect-char cur #\{)

    (let loop ([pairs '()])
      (skip-whitespace cur)
      (let ([ch (pstring-cursor-peek-char cur)])
        (cond
          [(eqv? ch #\}) (begin
                           (pstring-cursor-read-char cur)
                           pairs)]
          [(null? pairs) (loop (cons (read-object-pair cur) pairs))]
          [(eqv? ch #\,) (pstring-cursor-read-char cur)
                         (loop (cons (read-object-pair cur) pairs))]
          [else (error #f ("Expected comma or closing curly, got '~a'" ch))]))))

  (define (skip-whitespace cur)
    (define (whitespace-char? ch)
      (or (eqv? ch #\space)
          (eqv? ch #\newline)
          (eqv? ch #\return)
          (eqv? ch #\tab)))

    (when (whitespace-char? (pstring-cursor-peek-char cur))
      (pstring-cursor-read-char cur)
      (skip-whitespace cur)))

  ; ---------------------------------------------------
  ; JSON printer
  ; ---------------------------------------------------

  (define (json-stringify v)
    (define (string-escape str)
      (pstring-regex-replace-by
        (pstring-make-regex (string->pstring "[\"\\\\\\b\\f\\r\\n\\t]") '((global . #t)))
        str
        (lambda (match _)
          (let-values ([(ch _) (pstring-uncons-char match)])
            (cond
              [(eqv? ch #\") (pstring #\\ #\")]
              [(eqv? ch #\\) (pstring #\\ #\\)]
              [(eqv? ch #\backspace) (pstring #\\ #\b)]
              [(eqv? ch #\page) (pstring #\\ #\f)]
              [(eqv? ch #\return) (pstring #\\ #\r)]
              [(eqv? ch #\newline) (pstring #\\ #\n)]
              [(eqv? ch #\tab) (pstring #\\ #\t)])))))
    (cond
      [(pstring? v) (pstring-concat (pstring #\") (string-escape v) (pstring #\"))]
      [(number? v)
       (cond
         [(ratnum? v) (number->pstring (inexact v))]
         [else (number->pstring v)])]
      [(boolean? v) (if v true false)]
      [(eq? 'null v) null]
      [(srfi:214:flexvector? v)
       (pstring-concat
         (pstring #\[)
         (apply pstring-concat
                (srfi:214:flexvector-fold-right
                  (lambda (acc next)
                    (cons (json-stringify next)
                          (if (null? acc)
                            acc
                            (cons (pstring #\,) acc))))
                  '()
                  v))
         (pstring #\]))]
      [(list? v)
       (pstring-concat
         (pstring #\{)
         (apply pstring-concat
                ; Parser reverses the keys, and so does this.
                ; This keeps the original key order that was used when parsing.
                (fold-left
                  (lambda (acc next)
                    (cons (json-stringify (symbol->pstring (car next)))
                      (cons (pstring #\:)
                        (cons (json-stringify (cdr next))
                          (if (null? acc)
                            acc
                            (cons (pstring #\,) acc))))))
                  '()
                  v))
         (pstring #\}))]
      ))


  )
