;; -*- mode: scheme -*-

(library (Effect.Exception foreign)
  (export showErrorImpl
          error
          errorWithCause
          message
          name
          stackImpl
          throwException
          catchException)
  (import (only (rnrs base) define lambda if)
          (only (rnrs conditions)
            condition
            condition-message
            make-message-condition
            condition?
            message-condition?)
          (only (purescm pstring) pstring->string string->pstring)
          (only (rnrs io ports) call-with-string-output-port)
          (only (rnrs exceptions) with-exception-handler raise-continuable)
          (only (chezscheme) format call/cc display-condition))

  (define showErrorImpl
    (lambda (err)
      (string->pstring
        (if (condition? err)
          (call-with-string-output-port
            (lambda (p) (display-condition err p)))
          (format "Exception: ~s" err)))))

  (define error
    (lambda (msg)
      (make-message-condition (pstring->string msg))))

  (define errorWithCause
    (lambda (msg)
      (lambda (cause)
        (condition
          (make-message-condition (pstring->string msg))
          cause))))

  (define message
    (lambda (e)
      (string->pstring
        (if (message-condition? e)
          (condition-message e)
          (format "Exception: ~s" e)))))

  (define name
    (lambda (e)
      (string->pstring "Exception")))

  (define stackImpl
    (lambda (just)
      (lambda (nothing)
        (lambda (e)
          nothing))))

  (define throwException
    (lambda (e)
      (lambda ()
        (raise-continuable e))))

  (define catchException
    (lambda (c)
      (lambda (t)
        (lambda ()
          (call/cc
            (lambda (k)
              (with-exception-handler
                (lambda (e) (k ((c e))))
                (lambda () (t)))))))))
)
