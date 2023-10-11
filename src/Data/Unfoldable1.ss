;; -*- mode: scheme -*-

(library (Data.Unfoldable1 foreign)
  (export unfoldr1ArrayImpl)
  (import (only (rnrs base) define if lambda let)
          (prefix (purs runtime srfi :214) srfi:214:))

  (define unfoldr1ArrayImpl
    (lambda (isNothing)
      (lambda (fromJust)
        (lambda (fst)
          (lambda (snd)
            (lambda (f)
              (lambda (b)
                (let ([result (srfi:214:make-flexvector 0)])
                  (let recur ([value (f b)])
                    (srfi:214:flexvector-add-back! result (fst value))
                    (let ([maybe (snd value)])
                      (if (isNothing maybe)
                        result
                        (recur (f (fromJust maybe))))))))))))))
)
