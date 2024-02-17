;; -*- mode: scheme -*-

(library (Effect.Random foreign)
  (export random)
  (import (only (rnrs base) define lambda)
          (prefix (chezscheme) scm:))

  (define random
    (lambda ()
      (scm:random 1.0)))
)
