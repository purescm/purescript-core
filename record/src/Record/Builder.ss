(library (Record.Builder foreign)
  (export unsafeInsert unsafeModify unsafeDelete unsafeRename)
  (import (chezscheme)
          (prefix (purs runtime) rt:))
  
  (define unsafeInsert
    (lambda (l)
      (lambda (a)
        (lambda (rec)
          (rt:record-set rec (string->symbol l) a)))))

  (define unsafeModify
    (lambda (l)
      (lambda (f)
        (lambda (rec)
          (rt:record-set rec (string->symbol l) (f (rt:record-ref rec (string->symbol l))))))))

  (define unsafeDelete
    (lambda (l)
      (lambda (rec)
        (rt:record-remove rec (string->symbol l)))))

  (define unsafeRename
    (lambda (l1)
      (lambda (l2)
        (lambda (rec)
          (rt:record-remove
            (rt:record-set rec (string->symbol l2) (rt:record-ref rec (string->symbol l1)))
            (string->symbol l1))))))

  )
