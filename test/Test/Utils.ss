(library (Test.Utils foreign)
  (export throwErr)
  (import (chezscheme))

  (define throwErr
    (lambda (msg) 
      (raise-continuable
        (condition
          (make-serious-condition)
          (make-message-condition msg)))))

  )
