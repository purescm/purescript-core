;; -*- mode: scheme -*-

(library (Data.Show.Generic foreign)
  (export intercalate)
  (import (only (rnrs base) define lambda if let cond else = +)
          (only (purs runtime pstring) pstring pstring-concat)
          (prefix (purs runtime) rt:))

  (define intercalate
    (lambda (separator)
      (lambda (xs)
        (let ([len (rt:array-length xs)])
          (cond
            [(= len 0) (pstring)]
            [(= len 1) (rt:array-ref xs 0)]
            (else
              (let recur ([i 1]
                          [buffer (rt:array-ref xs 0)])
                (if (= len i)
                  buffer
                  (recur (+ i 1)
                         (pstring-concat buffer separator (rt:array-ref xs i)))))))))))

)
