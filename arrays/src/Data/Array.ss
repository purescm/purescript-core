(library (Data.Array foreign)
  (export rangeImpl
          replicateImpl
          fromFoldableImpl
          length
          unconsImpl
          indexImpl
          findMapImpl
          findIndexImpl
          findLastIndexImpl
          _insertAt
          _deleteAt
          _updateAt
          reverse
          concat
          filterImpl
          partitionImpl
          scanlImpl
          scanrImpl
          sortByImpl
          sliceImpl
          zipWithImpl
          anyImpl
          allImpl
          unsafeIndexImpl
          )
  (import (except (chezscheme) length reverse)
          (only (rnrs sorting) vector-sort!)
          (prefix (purs runtime) rt:)
          (prefix (purs runtime srfi :214) srfi:214:))

;;------------------------------------------------------------------------------
;; Array creation --------------------------------------------------------------
;;------------------------------------------------------------------------------

  (define rangeImpl
    (lambda (start end)
      (let* ([step (if (fx>? start end) -1 1)]
             [result (srfi:214:make-flexvector (+ (* step (- end start)) 1))])
        (let recur ([i start]
                    [n 0])
          (if (not (fx=? i end))
            (begin
              (srfi:214:flexvector-set! result n i)
              (recur (fx+ i step) (fx1+ n)))
            (begin
              (srfi:214:flexvector-set! result n i)
              result))))))

  (define replicateImpl
    (lambda (count value)
      (if (fx<? count 1)
        (rt:make-array)
        (let ([result (srfi:214:make-flexvector count)])
          (srfi:214:flexvector-fill! result value)
          result))))
      
  (define fromFoldableImpl
    (lambda (foldr xs)
      (define kons (lambda (head) (lambda (tail) (cons head tail))))
      (srfi:214:list->flexvector (((foldr kons) '()) xs))))

  (define length rt:array-length)

  (define unconsImpl
    (lambda (empty next xs)
      (if (fx=? (rt:array-length xs) 0)
        (empty 'unit)
        ((next (rt:array-ref xs 0)) (srfi:214:flexvector-copy xs 1)))))

  (define indexImpl
    (lambda (just nothing xs i)
      (if (or (fx<? i 0) (fx>=? i (rt:array-length xs)))
        nothing
        (just (rt:array-ref xs i)))))

  (define findMapImpl
    (lambda (nothing isJust f xs)
      (let ([len (rt:array-length xs)])
        (let recur ([i 0])
          (if (fx<? i len)
            (let ([result (f (rt:array-ref xs i))])
              (if (isJust result)
                result
                (recur (fx1+ i))))
            nothing)))))

  (define findIndexImpl
    (lambda (just nothing f xs)
      (let ([i (srfi:214:flexvector-index f xs)])
        (if (boolean? i)
          nothing
          (just i)))))

  (define findLastIndexImpl
    (lambda (just nothing f xs)
      (let ([i (srfi:214:flexvector-index-right f xs)])
        (if (boolean? i)
          nothing
          (just i)))))

  (define _insertAt
    (lambda (just nothing i a l)
      (if (or (fx<? i 0) (fx>? i (rt:array-length l)))
        nothing
        (let ([l1 (srfi:214:flexvector-copy l)])
          (srfi:214:flexvector-add! l1 i a)
          (just l1)))))

  (define _deleteAt
    (lambda (just nothing i l)
      (if (or (fx<? i 0) (fx>=? i (rt:array-length l)))
        nothing
        (let ([l1 (srfi:214:flexvector-copy l)])
          (srfi:214:flexvector-remove! l1 i)
          (just l1)))))

  (define _updateAt
    (lambda (just nothing i a l)
      (if (or (fx<? i 0) (fx>=? i (rt:array-length l)))
        nothing
        (let ([l1 (srfi:214:flexvector-copy l)])
          (srfi:214:flexvector-set! l1 i a)
          (just l1)))))


;;------------------------------------------------------------------------------
;; Transformations -------------------------------------------------------------
;;------------------------------------------------------------------------------

  (define reverse srfi:214:flexvector-reverse-copy)

  (define concat
    (lambda (xss)
      (srfi:214:flexvector-concatenate (srfi:214:flexvector->list xss))))

  (define filterImpl srfi:214:flexvector-filter)

  (define partitionImpl
    (lambda (f xs)
      (let-values ([(yes no) (srfi:214:flexvector-partition f xs)])
        (list (cons 'yes yes) (cons 'no no)))))

  (define scanlImpl
    (lambda (f b xs)
      (let* ([len (rt:array-length xs)]
             [out (srfi:214:make-flexvector len)])
        (let recur ([i 0]
                    [acc b])
          (if (fx<? i len)
            (let ([next ((f acc) (rt:array-ref xs i))])
              (srfi:214:flexvector-set! out i next)
              (recur (fx1+ i) next))
            out)))))

  (define scanrImpl
    (lambda (f b xs)
      (let* ([len (rt:array-length xs)]
             [out (srfi:214:make-flexvector len)])
        (let recur ([i (fx1- len)]
                    [acc b])
          (if (fx>=? i 0)
            (let ([next ((f (rt:array-ref xs i)) acc)])
              (srfi:214:flexvector-set! out i next)
              (recur (fx1- i) next))
            out)))))

;;------------------------------------------------------------------------------
;; Sorting ---------------------------------------------------------------------
;;------------------------------------------------------------------------------

  (define sortByImpl
    (lambda (compare fromOrdering xs)
      (let ([tmp (srfi:214:flexvector->vector xs)])
        (vector-sort!
          (lambda (x y) (fx>? (fromOrdering ((compare y) x)) 0))
          tmp)
        (srfi:214:vector->flexvector tmp))))


;;------------------------------------------------------------------------------
;; Subarrays -------------------------------------------------------------------
;;------------------------------------------------------------------------------

  (define sliceImpl
    (lambda (s e l)
      (if (fx>? s e)
        (rt:make-array)
        (srfi:214:flexvector-copy l s e))))

;;------------------------------------------------------------------------------
;; Zipping ---------------------------------------------------------------------
;;------------------------------------------------------------------------------

  (define zipWithImpl
    (lambda (f xs ys)
      (srfi:214:flexvector-map (lambda (x y) ((f x) y)) xs ys)))

;;------------------------------------------------------------------------------
;; Folding ---------------------------------------------------------------------
;;------------------------------------------------------------------------------

  (define anyImpl srfi:214:flexvector-any)

  (define allImpl srfi:214:flexvector-every)

;;------------------------------------------------------------------------------
;; Partial ---------------------------------------------------------------------
;;------------------------------------------------------------------------------

  (define unsafeIndexImpl
    (lambda (xs n)
      (rt:array-ref xs n)))
)

