(library (Effect foreign)
  (export throwErr pureE bindE)
  (import (chezscheme))

  (define pureE
    (lambda (a) (lambda () a)))

  (define bindE
    (lambda (a)
      (lambda (f)
        (lambda ()
          ((f (a)))))))
  )
