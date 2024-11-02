(library (Test.Foldable.Main foreign)
  (export arrayFrom1UpTo
          arrayReplicate
          mkNEArray
          foldMap1NEArray)
  (import (chezscheme)
          (prefix (purescm runtime) rt:)
          (prefix (srfi :214) srfi:214:))

  (define arrayFrom1UpTo
    (lambda (n)
      (srfi:214:flexvector-map/index
        (lambda (i x) (fx1+ i))
        (srfi:214:make-flexvector n))))

  (define arrayReplicate
    (lambda (n)
      (lambda (x)
        (let ([arr (srfi:214:make-flexvector n)])
          (srfi:214:flexvector-fill! arr x)))))

  (define mkNEArray
    (lambda (nothing)
      (lambda (just)
        (lambda (arr)
          (if (fx>? (srfi:214:flexvector-length arr) 0)
            (just arr)
            nothing)))))

  (define foldMap1NEArray
    (lambda (append)
      (lambda (f)
        (lambda (arr)
          (let ([len (srfi:214:flexvector-length arr)])
            (let recur ([acc (f (rt:array-ref arr 0))]
                        [i 1])
              (if (fx<? i len)
                (recur ((append acc) (f (rt:array-ref arr i))) (fx1+ i))
                acc)))))))

)
