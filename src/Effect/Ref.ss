;; -*- mode: scheme -*-

(library (Effect.Ref foreign)
  (export _new
          newWithSelf
          read
          modifyImpl
          write)
  (import (prefix (chezscheme) scm:))

  (scm:define _new
    (scm:lambda (v)
      (scm:lambda ()
        (scm:box v))))

  (scm:define newWithSelf
    (scm:lambda (f)
      (scm:lambda ()
        (scm:let ([ref (scm:box (scm:quote ()))])
          (scm:set-box! ref (f ref))
          ref))))

  (scm:define read
    (scm:lambda (ref)
      (scm:lambda ()
        (scm:unbox ref))))

  (scm:define modifyImpl
    (scm:lambda (f)
      (scm:lambda (ref)
        (scm:lambda ()
          (scm:let* ([t (f (scm:unbox ref))]
                     [v (scm:hashtable-ref t "state" (scm:quote Effect.Ref:modifyImpl-CANT-GET-STATE))])
            (scm:set-box! ref v)
            v)))))

  (scm:define write
    (scm:lambda (val)
      (scm:lambda (ref)
        (scm:lambda ()
          (scm:set-box! ref val)))))

)
