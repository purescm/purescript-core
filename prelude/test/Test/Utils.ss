(library (Test.Utils foreign)
  (export throwErr)
  (import (chezscheme) (only (purescm pstring) pstring->string))

  (define throwErr
    (lambda (msg) 
      (raise-continuable
        (condition
          (make-serious-condition)
          (make-message-condition (pstring->string msg))))))

  )
