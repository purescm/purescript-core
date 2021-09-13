;; -*- mode: scheme -*-

(library (Effect.Console foreign)
  (export log
          warn
          error
          info
          time
          timeLog
          timeEnd
          clear)
  (import (only (rnrs base) define lambda)
          (prefix (rnrs base) scm:))

  (define log
    (lambda (s)
      (lambda ()
        (scm:error #f "Effect.Console:log not implemented."))))

  (define warn
    (lambda (s)
      (lambda ()
        (scm:error #f "Effect.Console:warn not implemented."))))

  (define error
    (lambda (s)
      (lambda ()
        (scm:error #f "Effect.Console:error not implemented."))))

  (define info
    (lambda (s)
      (lambda ()
        (scm:error #f "Effect.Console:info not implemented."))))

  (define time
    (lambda (s)
      (lambda ()
        (scm:error #f "Effect.Console:time not implemented."))))

  (define timeLog
    (lambda (s)
      (lambda ()
        (scm:error #f "Effect.Console:timeLog not implemented."))))

  (define timeEnd
    (lambda (s)
      (lambda ()
        (scm:error #f "Effect.Console:timeEnd not implemented."))))

  (define clear
    (lambda ()
      (scm:error #f "Effect.Console:clear not implemented.")))

)
