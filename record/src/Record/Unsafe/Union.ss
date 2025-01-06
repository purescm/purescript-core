(library (Record.Unsafe.Union foreign)
  (export unsafeUnionFn)
  (import (chezscheme)
          (prefix (purescm runtime) rt:))

  (define unsafeUnionFn append)

)
