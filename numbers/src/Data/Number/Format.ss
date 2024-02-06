;; -*- mode: scheme -*-

(library (Data.Number.Format foreign)
  (export toPrecisionNative
          toFixedNative
          toExponentialNative
          toString)
  (import (only (rnrs base) define lambda string-append number->string)
          (only (chezscheme) format)
          (only (purs runtime pstring) string->pstring))

  ;; TODO add a proper implementation
  (define toPrecisionNative
    (lambda (d)
      (lambda (num)
        (string->pstring (format "~d" num)))))

  (define toFixedNative
    (lambda (d)
      (lambda (num)
        (string->pstring (format (string-append "~," (number->string d) "F") num)))))

  ;; TODO add a proper implementation
  (define toExponentialNative
    (lambda (d)
      (lambda (num)
        (string->pstring (format "~d" num)))))

  (define toString
    (lambda (num)
      (string->pstring (format "~d" num))))

)
