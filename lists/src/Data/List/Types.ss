(library (Data.List.Types foreign)
  (export foldrImpl
          foldlImpl
          mapImpl)
  (import (only (chezscheme) define lambda fold-right fold-left map))

  (define mapImpl map)

  (define foldrImpl (lambda (f b xs) (fold-right (lambda (a b) ((f a) b)) b xs)))

  (define foldlImpl (lambda (f b xs) (fold-left (lambda (b a) ((f b) a)) b xs)))

  )

