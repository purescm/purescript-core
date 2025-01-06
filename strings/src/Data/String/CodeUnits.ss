;; -*- mode: scheme -*-
(library (Data.String.CodeUnits foreign)
  (export
    fromCharArray
    toCharArray
    singleton
    _charAt
    _toChar
    _uncons
    length
    countPrefix
    _indexOf
    _indexOfStartingAt
    _lastIndexOf
    _lastIndexOfStartingAt
    take
    drop
    slice
    splitAt)
  (import
    (except (chezscheme) length)
    (only (purescm pstring) pstring-empty?
                                    pstring-singleton
                                    pstring-slice
                                    pstring-length
                                    string->pstring
                                    pstring-ref
                                    pstring-uncons-char
                                    pstring-take
                                    pstring-drop
                                    pstring-index-of
                                    pstring-last-index-of
                                    char-flexvector->pstring
                                    pstring->char-flexvector)
    (prefix (purescm runtime) rt:))

  (define fromCharArray char-flexvector->pstring)

  (define toCharArray pstring->char-flexvector)

  (define singleton pstring-singleton)

  (define _charAt
    (lambda (just)
      (lambda (nothing)
        (lambda (i)
          (lambda (s)
            (if (fx<? i (pstring-length s))
              (just (pstring-ref s i))
              nothing))))))

  (define _toChar
    (lambda (just)
      (lambda (nothing)
        (lambda (s)
          (if (fx=? (pstring-length s) 1)
            (just (pstring-ref s 0))
            nothing)))))

  (define _uncons
    (lambda (just)
      (lambda (nothing)
        (lambda (s)
          (if (pstring-empty? s)
            nothing
            (let-values ([(head tail) (pstring-uncons-char s)])
              (just (list (cons 'head head)
                          (cons 'tail tail)))))))))

  (define length pstring-length)

  (define countPrefix
    (lambda (p)
      (lambda (s)
        (let loop ([i 0] [rest s])
          (if (pstring-empty? rest)
            i
            (let-values ([(head tail) (pstring-uncons-char rest)])
              (if (p head)
                (loop (fx1+ i) tail)
                i)))))))

  (define take
    (lambda (n)
      (lambda (s)
        (pstring-take s n))))

  (define drop
    (lambda (n)
      (lambda (s)
        (pstring-drop s n))))

  (define _indexOf
    (lambda (just)
      (lambda (nothing)
        (lambda (pattern)
          (lambda (s)
            (let ([res (pstring-index-of s pattern)])
              (if (not res) nothing (just res))))))))

  (define _indexOfStartingAt
    (lambda (just)
      (lambda (nothing)
        (lambda (pattern)
          (lambda (startAt)
            (lambda (s)
              (if (or (fx<? startAt 0) (fx>? startAt (pstring-length s)))
                nothing
                (let ([res (pstring-index-of (pstring-slice s startAt) pattern)])
                  (if (not res) nothing (just (fx+ res startAt)))))))))))

  (define _lastIndexOf
    (lambda (just)
      (lambda (nothing)
        (lambda (pattern)
          (lambda (s)
            (let ([res (pstring-last-index-of s pattern)])
              (if (not res) nothing (just res))))))))

  (define _lastIndexOfStartingAt
    (lambda (just)
      (lambda (nothing)
        (lambda (pattern)
          (lambda (startAt)
            (lambda (s)
              (let* ([i (fx+ (fxmax 0 startAt) (pstring-length pattern))]
                     [res (pstring-last-index-of (pstring-slice s 0 i) pattern)])
                (if (not res) nothing (just res)))))))))

  (define slice
    (lambda (b)
      (lambda (e)
        (lambda (s)
          (let* ([len (pstring-length s)]
                 [bn (if (fx<? b 0) (fx+ len b) b)]
                 [en (if (fx<? e 0) (fx+ len e) e)])
            (pstring-slice s bn en))))))

  (define splitAt
    (lambda (i)
      (lambda (s)
        (list
          (cons 'before (pstring-slice s 0 i))
          (cons 'after (pstring-slice s i))))))

  )
