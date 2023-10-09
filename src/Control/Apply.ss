;; -*- mode: scheme -*-

(library (Control.Apply foreign)
  (export arrayApply)
  (import (only (rnrs base) define lambda let * + set!)
          (prefix (purs runtime lib) rt:)
          (prefix (purs runtime srfi :214) srfi:214:))

  (define arrayApply
    (lambda (fs)
      (lambda (xs)
        (let ([i 0]
              [buf (srfi:214:make-flexvector
                     (* (rt:array-length fs)
                        (rt:array-length xs)))])
          (srfi:214:flexvector-for-each
            (lambda (f)
              (srfi:214:flexvector-for-each
                (lambda (x)
                  (srfi:214:flexvector-set! buf i (f x))
                  (set! i (+ i 1)))
                xs)
              )
            fs)
          buf))))

)
