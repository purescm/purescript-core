;; -*- mode: scheme -*-

(library (Effect.Console foreign)
  (export log
          warn
          error
          info
          time
          timeLog
          timeEnd
          clear
          debug)
  (import (only (rnrs base) define lambda begin)
          (prefix (rnrs base) scm:)
          (only (rnrs io ports) current-output-port put-string)
          (only (rnrs io simple) newline))

  (define log
    (lambda (s)
      (lambda ()
        (begin 
          (put-string (current-output-port) s)
          (newline (current-output-port))))))

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

  (define debug
    (lambda (s)
      (lambda ()
        (scm:error #f "Effect.Console:debug not implemented."))))
)
