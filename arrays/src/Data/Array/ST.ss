(library (Data.Array.ST foreign)
  (export new
          unshiftAllImpl
          spliceImpl
          pokeImpl
          peekImpl
          popImpl
          unsafeThawImpl
          unsafeFreezeImpl
          lengthImpl
          shiftImpl
          pushImpl
          pushAllImpl
          toAssocArrayImpl
          sortByImpl
          thawImpl
          freezeImpl)
  (import (chezscheme)
          (only (rnrs sorting) vector-sort!)
          (prefix (purs runtime) rt:)
          (prefix (purs runtime srfi :214) srfi:214:))
          
  (define new
    (lambda () (rt:make-array)))

  (define lengthImpl rt:array-length)

  (define pokeImpl
    (lambda (i a xs)
      (let ([ret (and (>= i 0) (< i (rt:array-length xs)))])
        (if ret (srfi:214:flexvector-set! xs i a))
        ret)))

  (define peekImpl
    (lambda (just nothing i xs)
      (if (and (>= i 0) (< i (rt:array-length xs)))
        (just (rt:array-ref xs i))
        nothing)))

  (define popImpl
    (lambda (just nothing xs)
      (if (> (rt:array-length xs) 0)
        (just (srfi:214:flexvector-remove-back! xs))
        nothing)))

  (define unshiftAllImpl
    (lambda (as xs)
      (srfi:214:flexvector-add-all! xs 0 (srfi:214:flexvector->list as))
      (rt:array-length xs)))

  (define shiftImpl
    (lambda (just nothing xs)
      (if (> (rt:array-length xs) 0)
        (just (srfi:214:flexvector-remove-front! xs))
        nothing)))

  (define spliceImpl
    (lambda (i howMany bs xs)
      (if (> howMany 0)
        (let ([removed (srfi:214:make-flexvector howMany)])
          (srfi:214:flexvector-copy! removed 0 xs i (+ i howMany))
          (srfi:214:flexvector-remove-range! xs i (+ i howMany))
          (srfi:214:flexvector-add-all! xs i (srfi:214:flexvector->list bs))
          removed)
        (begin
          (srfi:214:flexvector-add-all! xs i (srfi:214:flexvector->list bs))
          (rt:make-array)))))

  (define unsafeThawImpl
    (lambda (xs) xs))

  (define unsafeFreezeImpl
    (lambda (xs) xs))

  (define pushImpl
    (lambda (a xs)
      (srfi:214:flexvector-add-back! xs a)
      (rt:array-length xs)))

  (define pushAllImpl
    (lambda (as xs)
      (srfi:214:flexvector-append! xs as)
      (rt:array-length xs)))

  ;; NOTE this is actually slower than the immutable
  ;; version in `Data.Array` because of the extra copy
  ;; operation
  (define sortByImpl
    (lambda (compare fromOrdering xs)
      (let ([tmp (srfi:214:flexvector->vector xs)])
        (vector-sort!
          (lambda (x y) (> (fromOrdering ((compare y) x)) 0))
          tmp)
        (srfi:214:flexvector-copy! xs 0 (srfi:214:vector->flexvector tmp)))))

  (define toAssocArrayImpl
    (lambda (xs)
      (srfi:214:flexvector-map/index
        (lambda (i x)
          (list (cons 'index i) (cons 'value x)))
        xs)))
            
  (define copyImpl
    (lambda (xs) (srfi:214:flexvector-copy xs)))

  (define thawImpl copyImpl)

  (define freezeImpl copyImpl)
)
