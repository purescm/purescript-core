;; -*- mode: scheme -*-

(library (Effect.Ref foreign)
  (export new
          newWithSelf
          read
          modifyImpl
          write)
  (import (only (rnrs base)
                define lambda quote let let* error cons car)
          (only (rnrs mutable-pairs) set-car!)
          (only (rnrs hashtables) hashtable-ref))

  (define new
    (lambda (val)
      (lambda ()
        (cons val '()))))

  (define newWithSelf
    (lambda (f)
      (lambda ()
        (let ([ref (cons '() '())])
          (set-car! ref (f ref))
          ref))))

  (define read
    (lambda (ref)
      (lambda ()
        (car ref))))

  (define modifyImpl
    (lambda (f)
      (lambda (ref)
        (lambda ()
          (let* ([t (f (car ref))]
                 [v (hashtable-ref
                     t
                     "state"
                     'Effect.Ref:modifyImpl-CANT-GET-STATE)])
            (set-car! ref v)
            v)))))

  (define write
    (lambda (val)
      (lambda (ref)
        (lambda ()
          (set-car! ref val)))))

)
