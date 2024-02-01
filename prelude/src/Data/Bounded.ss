;; -*- mode: scheme -*-

(library (Data.Bounded foreign)
  (export topInt bottomInt
          topChar bottomChar
          topNumber bottomNumber)
  (import (only (rnrs base) define quote integer->char)
          (chezscheme))

  (define topInt (most-positive-fixnum))
  (define bottomInt (most-negative-fixnum))

  (define topChar (integer->char 65535))
  (define bottomChar (integer->char 0))

  (define topNumber +inf.0)
  (define bottomNumber -inf.0)

)
