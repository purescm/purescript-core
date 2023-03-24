;; -*- mode: scheme -*-

(library (Data.Show.Generic foreign)
  (export intercalate)
  (import (only (rnrs base) define lambda error))

  (define intercalate
    (lambda (separator)
      (lambda (xs)
        (error #f "Data.Show.Generic:intercalate not implemented."))))

)
