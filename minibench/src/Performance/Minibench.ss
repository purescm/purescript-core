;; -*- mode: scheme -*-

(library (Performance.Minibench foreign)
  (export timeNs
          gc
          toFixed
  )

  (import (only (rnrs base) define let lambda quote)
          (only (chezscheme)
            collect format time-difference current-time time-nanosecond fixnum->flonum)
          (only (purs runtime pstring) string->pstring)
  )

  (define timeNs
    (lambda (k)
      (let ([start (current-time 'time-monotonic)])
        (k 'unit)
        (let ([end (current-time 'time-monotonic)])
          (fixnum->flonum (time-nanosecond (time-difference end start)))))))

  (define gc collect)

  (define toFixed
    (lambda (n)
      (string->pstring (format #f "~,2F" n))))
)
