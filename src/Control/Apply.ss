;; -*- mode: scheme -*-

(library (Control.Apply foreign)
  (export arrayApply)
  (import (only (rnrs base) define lambda)
          (prefix (purs runtime srfi :214) srfi:214:))

  (define arrayApply
    (lambda (fs)
      (lambda (xs)
        (srfi:214:flexvector-map (lambda (f x) (f x)) fs xs))))

)
