(library (JSON.Array foreign)
  (export singleton)
  (import (chezscheme)
          (prefix (purs runtime srfi :214) srfi:214:))

  (define (singleton x) (srfi:214:flexvector x))

  )

