(library (Data.String.Unsafe foreign)
  (export charAt char)
  (import (only (chezscheme) define lambda let-values)
          (only (purescm pstring) pstring-ref pstring-singleton pstring-uncons-char))

  (define charAt
    (lambda (n)
      (lambda (s)
        (pstring-ref s n))))

  (define char
    (lambda (s)
      (let-values ([(c _) (pstring-uncons-char s)])
        c)))

  )

