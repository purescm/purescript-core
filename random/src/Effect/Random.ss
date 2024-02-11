;; -*- mode: scheme -*-

(library (Random foreign)
  (export random)
  (import (only (rnrs base) define lambda))
  (import (prefix (chezscheme) scm:))

  (define random
    (lambda ()
      (random 1.0)))
)
