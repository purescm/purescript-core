(library (Data.String.CodePoints foreign)
  (export singleton
          fromCodePointArray
          toCodePointArray
          _codePointAt
          _uncons
          length
          countPrefix
          take
          unsafeCodePointAt0)
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

  ;; singleton :: CodePoint -> String
  (define singleton code-points->pstring)

  ;; fromCodePointArray :: Array CodePoint -> String
  (define fromCodePointArray
    (lambda (cps)
      (apply code-points->pstring (srfi:214:flexvector->list cps))))

  ;; toCodePointArray :: String -> Array CodePoint
  (define toCodePointArray pstring->code-point-flexvector)

  ;; _codePointAt :: (forall a. a -> Maybe a) -> (forall a. Maybe a) -> Int -> String -> Maybe CodePoint
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

  ;; _uncons :: (forall a. a -> Maybe a) -> (forall a. Maybe a) -> String -> Maybe { head :: CodePoint, tail :: String }
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

  ;; length :: String -> Int
  (define length pstring-length-code-points)

  ;; countPrefix :: (CodePoint -> Boolean) -> String -> Int
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

  ;; take :: Int -> String -> String
  (define take
    (lambda (n)
      (lambda (s)
        (pstring-take-code-points s n))))

  ;; unsafeCodePointAt0 :: String -> CodePoint
  (define unsafeCodePointAt0
    (lambda (s)
      (pstring-ref-code-point s 0)))

  )
