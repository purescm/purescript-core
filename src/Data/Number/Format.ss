;; -*- mode: scheme -*-

(library (Data.Number.Format foreign)
  (export toPrecisionNative
          toFixedNative
          toExponentialNative
          toString)
  (import (only (rnrs base) define lambda string-append number->string)
          (only (chezscheme) format))

  ;; TODO add a proper implementation
  (define toPrecisionNative
    (lambda (d)
      (lambda (num)
        (format "~d" num))))

  (define toFixedNative
    (lambda (d)
      (lambda (num)
        (format (string-append "~," (number->string d) "F") num))))

  ;; TODO add a proper implementation
  (define toExponentialNative
    (lambda (d)
      (lambda (num)
        (format "~d" num))))

  (define toString
    (lambda (num)
      (format "~d" num)))

)
