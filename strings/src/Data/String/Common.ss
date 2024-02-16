;; -*- mode: scheme -*-
(library (Data.String.Common foreign)
  (export _localeCompare replace replaceAll split toLower toUpper trim joinWith)
  (import
    (only (rnrs base) define lambda if)
    (only (purs runtime pstring) pstring<? pstring=?
                                    pstring-replace pstring-replace-all
                                    pstring-trim
                                    pstring-split
                                    pstring-downcase
                                    pstring-upcase
                                    pstring-join-with))

  ;; TODO This is the same as `Ord`
  (define _localeCompare
    (lambda (lt)
      (lambda (eq)
        (lambda (gt)
          (lambda (s1)
            (lambda (s2)
              (if (pstring<? s1 s2)
                  lt
                  (if (pstring=? s1 s2) eq gt))))))))

  (define replace
    (lambda (pattern)
      (lambda (replacement)
        (lambda (target)
          (pstring-replace target pattern replacement)))))

  (define replaceAll
    (lambda (pattern)
      (lambda (replacement)
        (lambda (target)
          (pstring-replace-all target pattern replacement)))))

  (define split
    (lambda (sep)
      (lambda (s)
        (pstring-split s sep))))

  (define toLower pstring-downcase)

  (define toUpper pstring-upcase)

  (define trim pstring-trim)

  (define joinWith
    (lambda (sep)
      (lambda (xs)
        (pstring-join-with xs sep))))
)
