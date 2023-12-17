(library (Data.Array.ST.Partial foreign)
  (export peekImpl pokeImpl)
  (import (only (rnrs base) define lambda quote)
          (prefix (purs runtime) rt:)
          (prefix (purs runtime srfi :214) srfi:214:))

  (define peekImpl
    (lambda (i xs)
      (rt:array-ref xs i)))

  (define pokeImpl
    (lambda (i a xs)
      (srfi:214:flexvector-set! xs i a)
      'unit))

)
