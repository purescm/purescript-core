(library (Record.Unsafe.Union foreign)
  (export unsafeUnionFn)
  (import (chezscheme)
          (prefix (purs runtime) rt:))

  (define unsafeUnionFn append)

)
