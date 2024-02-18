;; -*- mode: scheme -*-

(library (Test.QuickCheck.Gen foreign)
  (export float32ToInt32
  )

  (import (only (rnrs base) define let lambda quote)
          (prefix (chezscheme) scm:)
  )

  (define float32ToInt32
    (lambda (f)
      (let ([buf (scm:foreign-alloc 4)])
        (scm:foreign-set! (scm:quote single-float) buf 0 f)
        (let ([n (scm:foreign-ref (scm:quote integer-32) buf 0)])
          (scm:foreign-free buf)
          n))))
)
