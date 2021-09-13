;; -*- mode: scheme -*-

(library (Data.Ring foreign)
  (export intSub
          numSub)
  (import (only (rnrs base) define lambda error))

  (define intSub
    (lambda (x)
      (lambda (y)
        (error #f "Data.Ring:intSub not implemented."))))

  (define numSub
    (lambda (x)
      (lambda (y)
        (error #f "Data.Ring:numSub not implemented."))))

)
