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
          (only (purs runtime pstring) pstring->string)
          (only (rnrs io ports) current-output-port current-error-port put-string)
          (only (rnrs io simple) newline))

  (define log
    (lambda (s)
      (lambda ()
        (begin 
          (put-string (current-output-port) (pstring->string s))
          (newline (current-output-port))))))

  (define warn
    (lambda (s)
      (lambda ()
        (begin 
          (put-string (current-error-port) (pstring->string s))
          (newline (current-error-port))))))

  (define error
    (lambda (s)
      (lambda ()
        (begin 
          (put-string (current-error-port) (pstring->string s))
          (newline (current-error-port))))))

  (define info
    (lambda (s)
      (lambda ()
        (begin 
          (put-string (current-output-port) (pstring->string s))
          (newline (current-output-port))))))

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
        (begin 
          (put-string (current-output-port) (pstring->string s))
          (newline (current-output-port))))))
)
