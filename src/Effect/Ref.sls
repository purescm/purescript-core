;; -*- mode: scheme -*-

(library (Effect.Ref foreign)
  (export new
          newWithSelf
          read
          modifyImpl
          write)
  (import (only (rnrs base) define lambda error))

  (define new
    (lambda (val)
      (lambda ()
        (error #f "Effect.Ref:new not implemented."))))

  (define newWithSelf
    (lambda (f)
      (lambda ()
        (error #f "Effect.Ref:newWithSelf not implemented."))))

  (define read
    (lambda (ref)
      (lambda ()
        (error #f "Effect.Ref:read not implemented."))))

  (define modifyImpl
    (lambda (f)
      (lambda (ref)
        (lambda ()
          (error #f "Effect.Ref:modifyImpl not implemented.")))))

  (define write
    (lambda (val)
      (lambda (ref)
        (lambda ()
          (error #f "Effect.Ref:write not implemented.")))))

)
