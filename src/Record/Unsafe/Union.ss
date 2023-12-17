(library (Record.Unsafe.Union foreign)
  (export unsafeUnionFn)
  (import (only (rnrs base) define lambda let)
          (prefix (purs runtime) rt:)
          (prefix (purs runtime srfi :125) srfi:125:))

  (define unsafeUnionFn
    (lambda (r1 r2)
      (let ([r1copy (srfi:125:hash-table-copy r1)])
        (srfi:125:hash-table-union! r1copy r2))))

)
