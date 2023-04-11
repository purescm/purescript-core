(library (Record.Builder foreign)
  (export copyRecord unsafeInsert unsafeModify unsafeDelete unsafeRename)
  (import (prefix (chezscheme) scm:))
  
  (scm:define copyRecord
    (scm:lambda (rec)
      (scm:hashtable-copy rec #t)))

  (scm:define unsafeInsert
    (scm:lambda (l)
      (scm:lambda (a)
        (scm:lambda (rec)
          (scm:hashtable-set! rec l a)
          rec))))

  (scm:define unsafeModify
    (scm:lambda (l)
      (scm:lambda (f)
        (scm:lambda (rec)
          (scm:hashtable-set! rec l (f (scm:hashtable-ref rec l (scm:quote undefined))))
          rec))))

  (scm:define unsafeDelete
    (scm:lambda (l)
      (scm:lambda (rec)
        (scm:hashtable-delete! rec l)
        rec)))

  (scm:define unsafeRename
    (scm:lambda (l1)
      (scm:lambda (l2)
        (scm:lambda (rec)
          (scm:hashtable-set! rec l1 (scm:hashtable-ref rec l2 (scm:quote undefined)))
          (scm:hashtable-delete! rec l1)
          rec))))

  )
