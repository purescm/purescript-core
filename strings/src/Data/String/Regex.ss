(library (Data.String.Regex foreign)
  (export showRegexImpl
          regexImpl
          source
          flagsImpl
          test
          _match
          replace
          _replaceBy
          _search
          split
          )
  (import
    (except (chezscheme) length)
    (only (purs runtime pstring) pstring=?
                                    pstring-singleton
                                    pstring-slice
                                    pstring-length
                                    string->pstring
                                    pstring->string
                                    pstring-ref
                                    regex-source
                                    regex-flags
                                    pstring-make-regex
                                    pstring-regex-match
                                    pstring-regex-search
                                    pstring-regex-replace
                                    pstring-regex-replace-by)
    (prefix (purs runtime srfi :214) srfi:214:)
    (prefix (purs runtime) rt:))

  ;; NOTE: this doesn't include the flags as they are not part of the regex string
  (define showRegexImpl regex-source)

  (define regexImpl
    (lambda (left)
      (lambda (right)
        (lambda (s)
          (lambda (flags)
            (let ([regex (pstring-make-regex s flags)])
              (if regex
                (right regex)
                (left (string->pstring "error compiling regex")))))))))

  (define source regex-source)

  (define flagsImpl regex-flags)

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
        (error #f "unimplemented"))))


  )
