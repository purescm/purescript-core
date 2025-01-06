(library (JSON.Array foreign)
  (export singleton)
  (import (chezscheme)
          (prefix (srfi :214) srfi:214:))

  (define (singleton x) (srfi:214:flexvector x))

  )

