;; -*- mode: scheme -*-

(library (Control.Bind foreign)
  (export arrayBind)
  (import (chezscheme)
          (prefix (purs runtime) rt:)
          (prefix (purs runtime srfi :214) srfi:214:))

  (define arrayBind
    (lambda (arr)
      (lambda (f)
        (let ([len (rt:array-length arr)]
              [result (srfi:214:flexvector)])
          (let loop ([i 0])
            (if (fx=? i len)
              result
              (begin
                (srfi:214:flexvector-append! result (f (rt:array-ref arr i)))
                (loop (fx1+ i)))))))))

)
