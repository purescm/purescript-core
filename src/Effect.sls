;; -*- mode: scheme -*-

(library (Effect foreign)
  (export pureE
          bindE
          untilE
          whileE
          forE
          foreachE)
  (import (only (rnrs base) define lambda error))

  (define pureE
    (lambda (a)
      (lambda ()
        (error #f "Effect:pureE not implemented."))))

  (define bindE
    (lambda (a)
      (lambda (f)
        (lambda ()
          (error #f "Effect:bindE not implemented")))))

  (define untilE
    (lambda (f)
      (lambda ()
        (error #f "Effect:untilE not implemented"))))

  (define whileE
    (lambda (f)
      (lambda (a)
        (lambda ()
          (error #f "Effect:whileE not implemented.")))))

  (define forE
    (lambda (lo)
      (lambda (hi)
        (lambda (f)
          (lambda ()
            (error #f "Effect:forE not implemented."))))))

  (define foreachE
    (lambda (as)
      (lambda (f)
        (lambda ()
          (error #f "Effect:foreacE not implemented")))))

)
