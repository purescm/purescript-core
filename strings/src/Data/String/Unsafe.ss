(library (Data.String.Unsafe foreign)
  (export charAt char)
  (import (only (chezscheme) define lambda let-values)
          (only (purs runtime pstring) pstring-ref pstring-singleton pstring-uncons-code-unit))

  (define charAt
    (lambda (n)
      (lambda (s)
        (pstring-ref s n))))

  (define char
    (lambda (s)
      (let-values ([(c _) (pstring-uncons-code-unit s)])
        c)))

  )

