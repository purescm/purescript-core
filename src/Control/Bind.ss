;; -*- mode: scheme -*-

(library (Control.Bind foreign)
  (export arrayBind)
  (import (only (rnrs base) define lambda if = + begin let)
          (prefix (purs runtime) rt:)
          (prefix (purs runtime srfi :214) srfi:214:))

  (define arrayBind
    (lambda (arr)
      (lambda (f)
        (let ([len (rt:array-length arr)]
              [result (srfi:214:flexvector)])
          (let loop ([i 0])
            (if (= i len)
              result
              (begin
                (srfi:214:flexvector-append! result (f (rt:array-ref arr i)))
                (loop (+ i 1)))))))))

)
