;; -*- mode: scheme -*-

(library (Data.EuclideanRing foreign)
  (export intDegree
          intDiv
          intMod
          numDiv)
  (import (only (rnrs base) define lambda error))

  (define intDegree
    (lambda (x)
      (error #f "Data.EuclideanRing:intDegree not implemented")))

  (define intDiv
    (lambda (x)
      (lambda (y)
        (error #f "Data.EuclideanRing:intDiv not implemented"))))

  (define intMod
    (lambda (x)
      (lambda (y)
        (error #f "Data.EuclideanRing:intMod not implemented"))))

  (define numDiv
    (lambda (n1)
      (lambda (n2)
        (error #f "Data.EuclideanRing:numDiv not implemented"))))
)
