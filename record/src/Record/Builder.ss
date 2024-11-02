(library (Record.Builder foreign)
  (export unsafeInsert unsafeModify unsafeDelete unsafeRename)
  (import (chezscheme)
          (prefix (purescm runtime) rt:)
          (only (purescm pstring) pstring->symbol))
  
  (define unsafeInsert
    (lambda (l)
      (lambda (a)
        (lambda (rec)
          (rt:record-set rec (pstring->symbol l) a)))))

  (define unsafeModify
    (lambda (l)
      (lambda (f)
        (lambda (rec)
          (rt:record-set rec (pstring->symbol l) (f (rt:record-ref rec (pstring->symbol l))))))))

  (define unsafeDelete
    (lambda (l)
      (lambda (rec)
        (rt:record-remove rec (pstring->symbol l)))))

  (define unsafeRename
    (lambda (l1)
      (lambda (l2)
        (lambda (rec)
          (rt:record-remove
            (rt:record-set rec (pstring->symbol l2) (rt:record-ref rec (pstring->symbol l1)))
            (pstring->symbol l1))))))

  )
