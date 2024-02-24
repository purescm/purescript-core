;; -*- mode: scheme -*-

(library (Foreign.Object foreign)
  (export _copyST
          empty
          runST
          _fmapObject
          _mapWithKey
          _foldM
          _foldSCObject
          all
          size
          _lookup
          _lookupST
          fromHomogeneousImpl
          toArrayWithKey
          keys)
  (import (only (rnrs base) define lambda if let let-values begin)
          (prefix (chezscheme) scm:)
          (prefix (purs runtime srfi :214) arrays:)
          (only (purs runtime pstring) pstring->string string->pstring))

  (define _copyST
    (lambda (m)
      (lambda ()
        (scm:hashtable-copy m #t))))

  (define empty (scm:make-hashtable scm:string-hash scm:string=?))

  (define runST
    (lambda (f)
      (f)))

  (define _fmapObject
    (lambda (m0 f)
      (let ([m (scm:hashtable-copy m0 #t)])
        (scm:hash-table-for-each
          m0
          (lambda (k v)
            (scm:hashtable-set! m k (f v)))))))

  (define _mapWithKey
    (lambda (m0 f)
      (let ([m (scm:hashtable-copy m0 #t)])
        (scm:hash-table-for-each
          m0
          (lambda (k v)
            (scm:hashtable-set! m k ((f (string->pstring k)) v)))))))

  (define _foldM
    (lambda (bind)
      (lambda (f)
        (lambda (mz)
          (scm:trace-lambda foldMtrace (m)
            (let-values ([(ks vs) (scm:hashtable-entries m)])
              (let ([g (lambda (k)
                        (lambda (z)
                          (((f z) (string->pstring k)) (scm:hashtable-ref m k #f))))])
                (let loop ([ks (scm:vector->list ks)]
                          [vs (scm:vector->list vs)]
                          [acc mz])
                  (if (scm:null? ks)
                      acc
                      (loop (scm:cdr ks) (scm:cdr vs) ((bind acc) (g (scm:car ks)))))))))))))

  (define _foldSCObject 7)

  (define all
    (lambda (f)
      (scm:trace-lambda alltrace (m)
        (let-values ([(ks vs) (scm:hashtable-entries m)])
          (let loop ([ks (scm:vector->list ks)]
                    [vs (scm:vector->list vs)])
            (if (scm:null? ks)
                #t
                (if ((f (string->pstring (scm:car ks))) (scm:car vs))
                    (loop (scm:cdr ks) (scm:cdr vs))
                    #f)))))))

  (define size
    (lambda (m)
      (scm:hashtable-size m)))

  (define _lookup
    (lambda (no yes k m)
      (if (scm:hashtable-contains? m (pstring->string k))
          (yes (scm:hashtable-ref m (pstring->string k) #f))
          no)))

  (define _lookupST
    (lambda (no yes k m)
      (lambda ()
        (if (scm:hashtable-contains? m (pstring->string k))
            (yes (scm:hashtable-ref m (pstring->string k) #f))
            no))))

  (define fromHomogeneousImpl
    (lambda (r)
      (let loop ([r r] [acc (scm:make-hashtable scm:string-hash scm:string=?)])
        (if (scm:null? r)
            acc
            (let ([k (scm:caar r)]
                  [v (scm:cdar r)])
              (scm:hashtable-set! acc (scm:symbol->string k) v)
              (loop (scm:cdr r) acc))))))

  (define toArrayWithKey
    (scm:trace-lambda toArrayWithKey1 (f)
      (scm:trace-lambda toArrayWithKey2 (m)
        (let-values ([(ks vs) (scm:hashtable-entries m)])
          (let loop ([ks (scm:vector->list ks)]
                    [vs (scm:vector->list vs)]
                    [i 0]
                    [acc (arrays:make-flexvector (scm:hashtable-size m))])
            (if (scm:null? ks)
                acc
                (begin
                  (arrays:flexvector-set! acc i ((f (string->pstring (scm:car ks))) (scm:car vs)))
                  (loop (scm:cdr ks) (scm:cdr vs) (scm:+ i 1) acc))))))))

  (define keys
    (lambda (m)
      (arrays:flexvector-map! (lambda (k) (string->pstring k))
        (arrays:vector->flexvector
          (scm:hashtable-keys m)))))
)
