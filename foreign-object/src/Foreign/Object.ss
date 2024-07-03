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
          (only (purs runtime pstring) pstring->symbol symbol->pstring))

  (define _copyST
    (lambda (m)
      (lambda ()
        (scm:box (scm:list-copy (scm:unbox m))))))

  (define empty
    (scm:box (scm:quote ())))

  (define runST
    (lambda (f)
      (f)))

  (define _fmapObject
    (lambda (m0 f)
      (scm:box
        (scm:map
          (lambda (el)
            (let ([k (scm:car el)]
                  [v (scm:cdr el)])
              (scm:cons k (f v))))
          (scm:unbox m0)))))

  (define _mapWithKey
    (lambda (m0 f)
      (scm:box
        (scm:map
          (lambda (el)
            (let ([k (scm:car el)]
                  [v (scm:cdr el)])
              (scm:cons k ((f (symbol->pstring k)) v))))
          (scm:unbox m0)))))

  (define _foldM
    (lambda (bind)
      (lambda (f)
        (lambda (mz)
          (lambda (m)
            (let ([els1 (scm:reverse (scm:unbox m))]
                  [g (lambda (el)
                      (lambda (z)
                        (((f z) (symbol->pstring (scm:car el))) (scm:cdr el))))])
              (let loop ([els els1]
                        [acc mz])
                (if (scm:null? els)
                  acc
                  (loop (scm:cdr els) ((bind acc) (g (scm:car els))))))))))))

  (define _foldSCObject
    (lambda (m z f fromMaybe)
      (let loop ([els (scm:reverse (scm:unbox m))]
                [acc z])
        (if (scm:null? els)
          acc
          (let* ([el (scm:car els)]
                [k (scm:car el)]
                [v (scm:cdr el)]
                [maybeR (((f acc) (symbol->pstring k)) v)]
                [r ((fromMaybe (scm:quote undefined)) maybeR)])
            (if (scm:eq? r (scm:quote undefined))
              acc
              (loop (scm:cdr els) r)))))))

  (define all
    (lambda (f)
      (lambda (m)
        (let loop ([els (scm:unbox m)])
          (if (scm:null? els)
              #t
              (if ((f (symbol->pstring (scm:caar els))) (scm:cdar els))
                  (loop (scm:cdr els))
                  #f))))))

  (define size
    (lambda (m)
      (scm:length (scm:unbox m))))

  (define _lookup
    (lambda (no yes k m)
      (if (rt:record-has (scm:unbox m) (pstring->symbol k))
          (yes (rt:record-ref (scm:unbox m) (pstring->symbol k)))
          no)))

  (define _lookupST
    (lambda (no yes k m)
      (lambda ()
        (if (rt:record-has (scm:unbox m) (pstring->symbol k))
            (yes (rt:record-ref (scm:unbox m) (pstring->symbol k)))
            no))))

  (define fromHomogeneousImpl
    (lambda (r)
      (scm:box r)))

  (define toArrayWithKey
    (lambda (f)
      (lambda (m)
        (let* ([len (scm:length (scm:unbox m))]
              [arr (arrays:make-flexvector len)])
          (let loop ([i (scm:fx- len 1)]
                    [els (scm:unbox m)])
            (if (scm:null? els)
              arr
              (begin
                (let ([el (scm:car els)])
                  (arrays:flexvector-set! arr i ((f (symbol->pstring (scm:car el))) (scm:cdr el))))
                (loop (scm:fx- i 1) (scm:cdr els)))))))))

  (define keys
    (lambda (m)
      (arrays:list->flexvector
        (scm:map
          (lambda (el)
            (symbol->pstring (scm:car el)))
          (scm:reverse (scm:unbox m))))))
)
