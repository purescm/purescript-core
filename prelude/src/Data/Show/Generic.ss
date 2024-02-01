;; -*- mode: scheme -*-

(library (Data.Show.Generic foreign)
  (export intercalate)
  (import (only (rnrs base) define lambda if let cond else = + string-append)
          (prefix (purs runtime) rt:))

  (define intercalate
    (lambda (separator)
      (lambda (xs)
        (let ([len (rt:array-length xs)])
          (cond
            [(= len 0) ""]
            [(= len 1) (rt:array-ref xs 0)]
            (else
              (let recur ([i 1]
                          [buffer (rt:array-ref xs 0)])
                (if (= len i)
                  buffer
                  (recur (+ i 1) (string-append buffer separator (rt:array-ref xs i)))))))))))

)
