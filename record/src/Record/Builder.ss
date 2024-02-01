(library (Record.Builder foreign)
  (export copyRecord unsafeInsert unsafeModify unsafeDelete unsafeRename)
  (import (chezscheme)
          (prefix (purs runtime) rt:))
  
  (define copyRecord rt:object-copy)

  (define unsafeInsert
    (lambda (l)
      (lambda (a)
        (lambda (rec)
          (rt:object-set! rec (string->symbol l) a)
          rec))))

  (define unsafeModify
    (lambda (l)
      (lambda (f)
        (lambda (rec)
          (rt:object-set! rec (string->symbol l) (f (rt:object-ref rec (string->symbol l))))
          rec))))

  (define unsafeDelete
    (lambda (l)
      (lambda (rec)
        (hashtable-delete! rec (string->symbol l))
        rec)))

  (define unsafeRename
    (lambda (l1)
      (lambda (l2)
        (lambda (rec)
          (rt:object-set! rec (string->symbol l1) (rt:object-ref rec (string->symbol l2)))
          (symbol-hashtable-delete! rec (string->symbol l1))
          rec))))

  )
