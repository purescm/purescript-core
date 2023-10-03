;; -*- mode: scheme -*-

(library (Data.Number.Format foreign)
  (export toPrecisionNative
          toFixedNative
          toExponentialNative
          toString)
  (import (only (rnrs base) define lambda error))

  (define toPrecisionNative
    (lambda (num)
      (error #f "Data.Number.Format:toPrecisionNative not implemented.")))

  (define toFixedNative
    (lambda (num)
      (error #f "Data.Number.Format:toFixedNative not implemented.")))

  (define toExponentialNative
    (lambda (num)
      (error #f "Data.Number.Format:toExponentialNative not implemented.")))

  (define toString
    (lambda (num)
      (error #f "Data.Number.Format:toString not implemented.")))

)
