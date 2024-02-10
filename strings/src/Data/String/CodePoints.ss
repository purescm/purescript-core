(library (Data.String.CodePoints foreign)
  (export length
          unsafeCodePointAt0
          _codePointAt
          countPrefix
          fromCodePointArray
          toCodePointArray
          singleton
          _take
          _uncons)
  (import
    (except (chezscheme) length)
    (prefix (purs runtime) rt:)
    (prefix (purs runtime srfi :214) srfi:214:)
    (only (purs runtime pstring) code-points->pstring
                                 pstring->code-point-flexvector
                                 pstring-empty?
                                 pstring-length-code-points
                                 pstring-ref-code-point
                                 pstring-take-code-points
                                 pstring-uncons-code-point
                                 string->pstring)
    (only (chezscheme) fx1+ fx=?))

  (define length pstring-length-code-points)

  (define unsafeCodePointAt0
    (lambda (s)
      (pstring-ref-code-point s 0)))

  (define _codePointAt
    (lambda (Just)
      (lambda (Nothing)
        (lambda (index)
          (lambda (s)
            (let loop ([i 0] [cur s])
              (if (pstring-empty? cur)
                Nothing
                (let-values ([(head tail) (pstring-uncons-code-point cur)])
                  (if (fx=? i index)
                    (Just head)
                    (loop (fx1+ i) tail))))))))))

  (define countPrefix
    (lambda (pred)
      (lambda (s)
        (let loop ([count 0] [rest s])
          (if (pstring-empty? rest)
            count
            (let-values ([(head tail) (pstring-uncons-code-point rest)])
              (if (pred head)
                (loop (fx1+ count) tail)
                count)))))))

  (define fromCodePointArray
    (lambda (cps)
      (apply code-points->pstring (srfi:214:flexvector->list cps))))

  (define singleton code-points->pstring)

  (define _take
    (lambda (n)
      (lambda (s)
        (pstring-take-code-points s n))))

  (define _uncons
    (lambda (Just)
      (lambda (Nothing)
        (lambda (s)
          (if (pstring-empty? s)
            Nothing
            (let-values ([(c tail) (pstring-uncons-code-point s)])
              (Just (list
                      (cons 'head c)
                      (cons 'tail tail)))))))))

  (define toCodePointArray pstring->code-point-flexvector)

  )
