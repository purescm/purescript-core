;; -*- mode: scheme -*-

(library (Data.Show.Generic foreign)
  (export intercalate)
  (import (chezscheme)
          (only (purescm pstring) pstring pstring-concat)
          (prefix (purescm runtime) rt:))

  (define intercalate
    (lambda (separator)
      (lambda (xs)
        (let ([len (rt:array-length xs)])
          (cond
            [(fx=? len 0) (pstring)]
            [(fx=? len 1) (rt:array-ref xs 0)]
            (else
              (let recur ([i 1]
                          [buffer (rt:array-ref xs 0)])
                (if (fx=? len i)
                  buffer
                  (recur (fx1+ i)
                         (pstring-concat buffer separator (rt:array-ref xs i)))))))))))

)
