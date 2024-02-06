(library (Test.Data.String.CodePoints foreign)
  (export str)
  (import
    (only (rnrs base) define lambda)
    (only (purs runtime pstring) code-points->pstring))

  (define str (code-points->pstring #x61 #xDC00 #xD800 #xD800 #x16805 #x16A06 #x7A))
  )
