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
    (lambda (v)
      (lambda ()
        (box v))))

  (define newWithSelf
    (lambda (f)
      (lambda ()
        (let ([ref (box '())])
          (set-box! ref (f ref))
          ref))))

  (define read
    (lambda (ref)
      (lambda ()
        (unbox ref))))

  ;; modify' :: forall s b. (s -> { state :: s, value :: b }) -> Ref s -> Effect b

  (define modifyImpl
    (lambda (f)
      (lambda (ref)
        (lambda ()
          (let* ([t (f (unbox ref))]
                 [v (hashtable-ref t "state" 'Effect.Ref:modifyImpl-CANT-GET-STATE)])
            (set-box! ref v)
            v)))))

  (define write
    (lambda (val)
      (lambda (ref)
        (lambda ()
          (set-box! ref val)))))

)
