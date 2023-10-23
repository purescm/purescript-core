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
  (import (only (rnrs base) define lambda let error + -)
          (prefix (purs runtime lib) rt:)
          (prefix (purs runtime srfi :214) srfi:214:))

;;------------------------------------------------------------------------------
;; Array creation --------------------------------------------------------------
;;------------------------------------------------------------------------------

  (define rangeImpl
    (lambda (start end)
      (let ([res (srfi:214:make-flexvector (+ (- end start) 1))])
        (srfi:214:flexvector-map/index! (lambda (i x) (+ i start)) res)
        res)))

  (define replicateImpl
    (lambda (count value)
      (error #f "replicateImpl not implemented")))

  (define fromFoldableImpl
    (lambda (foldr xs)
      (error #f "fromFoldableImpl not implemented")))

  (define length
    (lambda (xs)
      (error #f "length not implemented")))

  (define unconsImpl
    (lambda (empty next xs)
      (error #f "unconsImpl not implemented")))

  (define indexImpl
    (lambda (just nothing xs i)
      (error #f "indexImpl not implemented")))

  (define findMapImpl
    (lambda (nothing isJust f xs)
      (error #f "findMapImpl not implemented")))

  (define findIndexImpl
    (lambda (just nothing f xs)
      (error #f "findIndexImpl not implemented")))

  (define findLastIndexImpl
    (lambda (just nothing f xs)
      (error #f "findLastIndexImpl not implemented")))

  (define _insertAt
    (lambda (just nothing i a l)
      (error #f "_insertAt not implemented")))

  (define _deleteAt
    (lambda (just nothing i l)
      (error #f "_deleteAt not implemented")))

  (define _updateAt
    (lambda (just nothing i a l)
      (error #f "_updateAt not implemented")))

;;------------------------------------------------------------------------------
;; Transformations -------------------------------------------------------------
;;------------------------------------------------------------------------------

  (define reverse
    (lambda (l)
      (error #f "reverse not implemented")))

  (define concat
    (lambda (xss)
      (error #f "concat not implemented")))

  (define filterImpl
    (lambda (f xs)
      (error #f "filterImpl not implemented")))

  (define partitionImpl
    (lambda (f xs)
      (error #f "partitionImpl not implemented")))

  (define scanlImpl
    (lambda (f b xs)
      (error #f "scanlImpl not implemented")))

  (define scanrImpl
    (lambda (f b xs)
      (error #f "scanrImpl not implemented")))

;;------------------------------------------------------------------------------
;; Sorting ---------------------------------------------------------------------
;;------------------------------------------------------------------------------

  (define sortByImpl
    (lambda (compare fromOrdering xs)
      (error #f "sortByImpl not implemented")))

;;------------------------------------------------------------------------------
;; Subarrays -------------------------------------------------------------------
;;------------------------------------------------------------------------------

  (define sliceImpl
    (lambda (s e l)
      (error #f "sliceImpl not implemented")))

;;------------------------------------------------------------------------------
;; Zipping ---------------------------------------------------------------------
;;------------------------------------------------------------------------------

  (define zipWithImpl
    (lambda (f xs ys)
      (error #f "zipWithImpl not implemented")))

;;------------------------------------------------------------------------------
;; Folding ---------------------------------------------------------------------
;;------------------------------------------------------------------------------

  (define anyImpl
    (lambda (p xs)
      (error #f "anyImpl not implemented")))

  (define allImpl
    (lambda (p xs)
      (error #f "allImpl not implemented")))

;;------------------------------------------------------------------------------
;; Partial ---------------------------------------------------------------------
;;------------------------------------------------------------------------------

  (define unsafeIndexImpl
    (lambda (xs n)
      (rt:array-ref xs n)))
)

