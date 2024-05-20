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
  (import (only (rnrs base) define lambda if let let* let-values begin)
          (prefix (chezscheme) scm:)
          (prefix (purs runtime) rt:)
          (prefix (purs runtime srfi :214) arrays:)
          (only (purs runtime pstring) pstring->symbol string->pstring))

  (define symbol->pstring
    (lambda (s)
      (string->pstring (scm:symbol->string s))))

  (define _copyST
    (lambda (m)
      (lambda ()
        (scm:cons
          (scm:hashtable-copy (scm:car m) #t)
          (scm:list-copy (scm:cdr m))))))

  (define empty
    (scm:cons
      (scm:make-hashtable scm:symbol-hash scm:symbol=? 32)
      (scm:quote ())))

  (define runST
    (lambda (f)
      (f)))

  (define _fmapObject
    (lambda (m0 f)
      (let ([m (scm:hashtable-copy (scm:car m0) #t)])
        (let-values ([(ks1 vs1) (scm:hashtable-entries (scm:car m0))])
          (let loop ([ks (scm:vector->list ks1)]
                    [vs (scm:vector->list vs1)])
            (if (scm:null? ks)
                (scm:cons m (scm:list-copy (scm:cdr m0)))
                (begin
                  (scm:symbol-hashtable-set! m (scm:car ks) (f (scm:car vs)))
                  (loop (scm:cdr ks) (scm:cdr vs)))))))))

  (define _mapWithKey
    (lambda (m0 f)
      (let ([m (scm:hashtable-copy (scm:car m0) #t)])
        (let-values ([(ks1 vs1) (scm:hashtable-entries (scm:car m0))])
          (let loop ([ks (scm:vector->list ks1)]
                    [vs (scm:vector->list vs1)])
            (if (scm:null? ks)
                (scm:cons m (scm:list-copy (scm:cdr m0)))
                (begin
                  (scm:symbol-hashtable-set! m (scm:car ks) ((f (symbol->pstring (scm:car ks))) (scm:car vs)))
                  (loop (scm:cdr ks) (scm:cdr vs)))))))))

  (define _foldM
    (lambda (bind)
      (lambda (f)
        (lambda (mz)
          (lambda (m)
            (let ([ks1 (scm:reverse (scm:cdr m))]
                  [g (lambda (k)
                      (lambda (z)
                        (((f z) (symbol->pstring k)) (scm:symbol-hashtable-ref (scm:car m) k #f))))])
              (let loop ([ks ks1]
                        [acc mz])
                (if (scm:null? ks)
                  acc
                  (loop (scm:cdr ks) ((bind acc) (g (scm:car ks))))))))))))

  (define _foldSCObject
    (lambda (m z f fromMaybe)
      (let ([ks1 (scm:reverse (scm:cdr m))])
        (let loop ([ks ks1]
                  [acc z])
          (if (scm:null? ks)
            acc
            (let* ([k (scm:car ks)]
                  [v (scm:symbol-hashtable-ref (scm:car m) k #f)]
                  [maybeR (((f acc) (symbol->pstring k)) v)]
                  [r ((fromMaybe (scm:quote undefined)) maybeR)])
              (if (scm:eq? r (scm:quote undefined))
                acc
                (loop (scm:cdr ks) r))))))))

  (define all
    (lambda (f)
      (lambda (m)
        (let-values ([(ks vs) (scm:hashtable-entries (scm:car m))])
          (let loop ([ks (scm:vector->list ks)]
                    [vs (scm:vector->list vs)])
            (if (scm:null? ks)
                #t
                (if ((f (symbol->pstring (scm:car ks))) (scm:car vs))
                    (loop (scm:cdr ks) (scm:cdr vs))
                    #f)))))))

  (define size
    (lambda (m)
      (scm:hashtable-size (scm:car m))))

  (define _lookup
    (lambda (no yes k m)
      (if (scm:symbol-hashtable-contains? (scm:car m) (pstring->symbol k))
          (yes (scm:symbol-hashtable-ref (scm:car m) (pstring->symbol k) #f))
          no)))

  (define _lookupST
    (lambda (no yes k m)
      (lambda ()
        (if (scm:symbol-hashtable-contains? (scm:car m) (pstring->symbol k))
            (yes (scm:symbol-hashtable-ref (scm:car m) (pstring->symbol k) #f))
            no))))

  (define fromHomogeneousImpl
    (lambda (r)
      (let loop ([r r]
                [ht (scm:make-hashtable scm:symbol-hash scm:symbol=?)]
                [ks (scm:quote ())])
        (if (scm:null? r)
            (scm:cons ht ks)
            (let ([k (scm:caar r)]
                  [v (scm:cdar r)])
              (scm:symbol-hashtable-set! ht k v)
              (loop (scm:cdr r) ht (scm:cons k ks)))))))

  (define toArrayWithKey
    (lambda (f)
      (lambda (m)
        (let ([ks1 (scm:reverse (scm:cdr m))])
          (let loop ([ks ks1]
                    [vs (scm:map (lambda (k) (scm:symbol-hashtable-ref (scm:car m) k #f)) ks1)]
                    [i 0]
                    [acc (arrays:make-flexvector (scm:length ks1))])
            (if (scm:null? ks)
              acc
              (begin
                (arrays:flexvector-set! acc i ((f (symbol->pstring (scm:car ks))) (scm:car vs)))
                (loop (scm:cdr ks) (scm:cdr vs) (scm:+ i 1) acc))))))))

  (define keys
    (lambda (m)
      (arrays:list->flexvector
        (scm:map
          symbol->pstring
          (scm:reverse (scm:cdr m))))))
)
