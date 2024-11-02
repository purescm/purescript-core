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
    (prefix (purescm runtime) rt:)
    (prefix (srfi :214) srfi:214:)
    (only (purescm pstring) code-points->pstring
                                 pstring->code-point-flexvector
                                 pstring-empty?
                                 pstring-length-code-points
                                 pstring-ref-code-point
                                 pstring-take-code-points
                                 pstring-cursor-read-code-point
                                 pstring->cursor
                                 cursor->pstring)
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
            (let ([cur (pstring->cursor s)])
              (let loop ([i 0] [cp (pstring-cursor-read-code-point cur)])
                (cond
                  [(eof-object? cp) Nothing]
                  [(fx=? i index) (Just cp)]
                  [else (loop (fx1+ i) (pstring-cursor-read-code-point cur))]))))))))

  (define countPrefix
    (lambda (pred)
      (lambda (s)
        (let ([cursor (pstring->cursor s)])
          (let loop ([count 0])
            (let ([cp (pstring-cursor-read-code-point cursor)])
              (cond
                [(eof-object? cp) count]
                [(pred cp) (loop (fx1+ count))]
                [else count])))))))

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
          (let* ([cur (pstring->cursor s)]
                 [cp (pstring-cursor-read-code-point cur)])
            (if (eof-object? cp)
              Nothing
              (Just (list
                    (cons 'head cp)
                    (cons 'tail (cursor->pstring cur))))))))))

  (define toCodePointArray pstring->code-point-flexvector)

  )
