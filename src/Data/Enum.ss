;; -*- mode: scheme -*-

(library (Data.Enum foreign)
  (export toCharCode
          fromCharCode)
  (import (only (rnrs base) define lambda)
          (only (chezscheme) char->integer integer->char))

  (define toCharCode
    (lambda (c) (char->integer c)))

  (define fromCharCode
    (lambda (c) (integer->char c)))
)
