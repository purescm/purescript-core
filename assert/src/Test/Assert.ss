(library (Test.Assert foreign)
  (export assertImpl checkThrows)
  (import (chezscheme)
          (only (purs runtime pstring) pstring->string))

  (define assertImpl
    (lambda (message)
      (lambda (success)
        (lambda ()
          (when (not success)
            (raise-continuable
              (condition
                (make-message-condition (pstring->string message)))))))))

  (define checkThrows
    (lambda (fn)
      (lambda ()
        (call/cc (lambda (k)
          (with-exception-handler
            (lambda (e) (k #t))
            (lambda () (begin (fn 'unit) #f))))))))

  )
