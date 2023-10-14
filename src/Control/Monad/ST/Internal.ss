(library (Control.Monad.ST.Internal foreign)
  (export map_ pure_ bind_ run while read for
          new foreach modifyImpl write)

  (import (only (rnrs base) define lambda let quote if begin list cons = +)
          (only (chezscheme) do)
          (prefix (purs runtime srfi :214) srfi:214:)
          (prefix (purs runtime lib) rt:))

  (define map_
    (lambda (f)
      (lambda (a)
        (lambda ()
          (f (a))))))

  (define pure_
    (lambda (a)
      (lambda ()
        a)))

  (define bind_
    (lambda (a)
      (lambda (f)
        (lambda ()
          ((f (a)))))))

  (define run
    (lambda (f)
      (f)))

  (define while
    (lambda (f)
      (lambda (a)
        (lambda ()
          (let loop ()
            (if (f)
              (begin (a) (loop))
              'unit))))))

  (define for
    (lambda (lo)
      (lambda (hi)
        (lambda (f)
          (lambda ()
            (do ([i lo (+ i 1)]) ((= i hi) 'unit)
              ((f i))))))))

  (define foreach
    (lambda (as)
      (lambda (f)
        (lambda ()
          (srfi:214:flexvector-for-each (lambda (x) ((f x))) as)))))

  (define new
    (lambda (val)
      (lambda ()
        (rt:make-object (list (cons "value" val))))))

  (define read
    (lambda (ref)
      (lambda ()
        (rt:object-ref ref "value"))))

  (define modifyImpl
    (lambda (f)
      (lambda (ref)
        (let ([t (f (rt:object-ref ref "value"))])
          (rt:object-set! ref "value" (rt:object-ref t "state"))
          (rt:object-ref t "value")))))

  (define write
    (lambda (a)
      (lambda (ref)
        (lambda ()
          (rt:object-set! ref "value" a)
          a))))
)
