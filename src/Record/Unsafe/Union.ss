(library (Record.Unsafe.Union foreign)
  (export unsafeUnionFn)
  (import (prefix (chezscheme) scm:))

  (scm:define unsafeUnionFn
    (scm:lambda (r1 r2))
      (scm:error #f "unsafeUnionFn: unimplemented!"))
  )
