(library (Record.Unsafe.Union foreign)
  (export unsafeUnionFn)
  (import (chezscheme)
          (prefix (purs runtime) rt:))

  (define (hashtable-for-each f ht)
    (let-values ([(keys values) (hashtable-entries ht)])
      (vector-for-each f keys values)))

  (define unsafeUnionFn
    (lambda (r1 r2)
      (let ([r1copy (rt:object-copy r1)])
        (hashtable-for-each
          (lambda (key2 val2)
            (if (not (symbol-hashtable-contains? r1copy key2))
                (rt:object-set! r1copy key2 val2)))
          r2)
        r1copy)))

)
