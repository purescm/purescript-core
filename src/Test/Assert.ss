(library (Test.Assert foreign)
  (export assertImpl checkThrows)
  (import (chezscheme))

  (define assertImpl
    (lambda (message)
      (lambda (success)
        (lambda ()
          (if (not success) 
            (raise-continuable
              (condition
                (make-serious-condition)
                (make-message-condition message))))))))

  (define checkThrows
    (lambda (fn)
      (lambda ()
        (with-exception-handler
          (lambda (e)
            (unless (serious-condition? e)
              (raise
                (condition
                  (make-violation)
                  (make-message-condition "Threw something other than a serious condition"))))
            #t)
          (lambda () (eq? (fn 'unit) #t))))))

  )
