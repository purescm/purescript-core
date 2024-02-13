;; -*- mode: scheme -*-

(library (Effect.Ref foreign)
  (export _new
          newWithSelf
          read
          modifyImpl
          write)
  (import (prefix (chezscheme) scm:)
          (prefix (purs runtime) rt:))

  (scm:define _new
    (scm:lambda (v)
      (scm:lambda ()
        (scm:cons (scm:box v) (scm:make-mutex)))))

  (scm:define newWithSelf
    (scm:lambda (f)
      (scm:lambda ()
        (scm:let ([ref (scm:cons (scm:box (scm:quote ())) (scm:make-mutex))])
          (scm:set-box! (scm:car ref) (f ref))
          ref))))

  (scm:define read
    (scm:lambda (ref)
      (scm:lambda ()
        (scm:unbox (scm:car ref)))))

  (scm:define modifyImpl
    (scm:lambda (f)
      (scm:lambda (ref)
        (scm:lambda ()
          (scm:with-mutex (scm:cdr ref)
            (scm:let* ([t (f (scm:unbox (scm:car ref)))]
                       [v (rt:record-ref t (scm:quote state))])
              (scm:set-box! (scm:car ref) v)
              v))))))

  (scm:define write
    (scm:lambda (val)
      (scm:lambda (ref)
        (scm:lambda ()
          (scm:with-mutex (scm:cdr ref)
            (scm:set-box! (scm:car ref) val))))))

)
