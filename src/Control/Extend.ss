;; -*- mode: scheme -*-

(library (Control.Extend foreign)
  (export arrayExtend)
  (import (only (rnrs base) define lambda)
          (prefix (purs runtime srfi :214) srfi:214:))

  (define arrayExtend
    (lambda (f)
      (lambda (xs)
        (srfi:214:flexvector-map/index
          (lambda (i _) (f (srfi:214:flexvector-copy xs i)))
          xs))))

)
