;; -*- mode: scheme -*-

(library (Data.Bounded foreign)
  (export topInt bottomInt
          topChar bottomChar
          topNumber bottomNumber)
  (import (only (rnrs base) define quote))

  (define topInt 'Data.Bounded:topInt-NOT-DEFINED)
  (define bottomInt 'Data.Bounded:bottomInt-NOT-DEFINED)

  (define topChar 'Data.Bounded:topChar-NOT-DEFINED)
  (define bottomChar 'Data.Bounded:bottomChar-NOT-DEFINED)

  (define topNumber 'Data.Bounded:topNumber-NOT-DEFINED)
  (define bottomNumber 'Data.Bounded:bottomNumber-NOT-DEFINED)

)
