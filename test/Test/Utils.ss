(library (Test.Utils foreign)
  (export throwErr pureE bindE)
  (import (chezscheme))

  (define throwErr
    (lambda (msg) 
      (raise-continuable
        (condition
          (make-serious-condition)
          (make-message-condition msg)))))

  (define pureE
    (lambda (a) (lambda () a)))

  (define bindE
    (lambda (a)
      (lambda (f)
        (lambda ()
          ((f (a)))))))
  )
