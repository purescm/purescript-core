(library (Data.Array.ST.Partial foreign)
  (export peekImpl pokeImpl)
  (import (only (rnrs base) define lambda quote)
          (prefix (purescm runtime) rt:)
          (prefix (srfi :214) srfi:214:))

  (define peekImpl
    (lambda (i xs)
      (rt:array-ref xs i)))

  (define pokeImpl
    (lambda (i a xs)
      (srfi:214:flexvector-set! xs i a)
      'unit))

)
