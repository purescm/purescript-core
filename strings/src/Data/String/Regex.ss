(library (Data.String.Regex foreign)
  (export flagsImpl
          _match
          regexImpl
          replace
          _replaceBy
          _search
          showRegexImpl
          source
          split
          test)
  (import
    (except (chezscheme) length)
    (only (purescm pstring) pstring=?
                                 pstring-length
                                 pstring-make-regex
                                 pstring-ref
                                 pstring-regex-match
                                 pstring-regex-replace
                                 pstring-regex-replace-by
                                 pstring-regex-search
                                 pstring-regex-split
                                 pstring-singleton
                                 pstring-slice
                                 pstring->string
                                 regex-orig-flags
                                 regex-source
                                 string->pstring)
    (prefix (srfi :214) srfi:214:)
    (prefix (purescm runtime) rt:))

  ;; NOTE: this doesn't include the flags as they are not part of the regex string
  (define showRegexImpl regex-source)

  ;; Parse a rendered flags string (e.g. "gims") into the alist format
  ;; that pstring-make-regex expects: ((global . #t) (ignoreCase . #t) ...)
  (define (parse-flags-string flags-pstring)
    (let ([s (pstring->string flags-pstring)])
      (list
        (cons 'global (string-contains s "g"))
        (cons 'ignoreCase (string-contains s "i"))
        (cons 'multiline (string-contains s "m"))
        (cons 'dotAll (string-contains s "s"))
        (cons 'sticky (string-contains s "y"))
        (cons 'unicode (string-contains s "u")))))

  ;; Helper: check if a Scheme string contains a character substring
  (define (string-contains s sub)
    (let loop ([i 0])
      (cond
        [(> (+ i (string-length sub)) (string-length s)) #f]
        [(string=? (substring s i (+ i (string-length sub))) sub) #t]
        [else (loop (+ i 1))])))

  (define regexImpl
    (lambda (left)
      (lambda (right)
        (lambda (s)
          (lambda (flags-str)
            (let ([regex (pstring-make-regex s (parse-flags-string flags-str))])
              (if regex
                (right regex)
                (left (string->pstring "error compiling regex")))))))))

  (define source regex-source)

  (define flagsImpl regex-orig-flags)

  (define test
    (lambda (r)
      (lambda (s)
        (let ([match (pstring-regex-match r s (lambda (x) x) #f)])
          (if match #t #f)))))

  (define _match
    (lambda (just)
      (lambda (nothing)
        (lambda (r)
          (lambda (s)
            (let ([matches (pstring-regex-match r s just nothing)])
              (if matches (just matches) nothing)))))))


  (define replace
    (lambda (r)
      (lambda (replacement)
        (lambda (s)
          (pstring-regex-replace r s replacement)))))

  (define _replaceBy
    (lambda (just)
      (lambda (nothing)
        (lambda (regex)
          (lambda (f)
            (lambda (subject)
              (pstring-regex-replace-by
                regex
                subject
                (lambda (match xs)
                  (let ([sub-matches (srfi:214:flexvector-map (lambda (m) (if m (just m) nothing)) xs)])
                    ((f match) sub-matches))))))))))

  (define _search
    (lambda (just)
      (lambda (nothing)
        (lambda (r)
          (lambda (s)
            (let ([res (pstring-regex-search r s)])
              (if (not res)
                nothing
                (just res))))))))

  (define split
    (lambda (r)
      (lambda (s)
        (pstring-regex-split r s))))


  )
