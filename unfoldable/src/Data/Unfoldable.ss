;; -*- mode: scheme -*-

(library (Data.Unfoldable foreign)
  (export unfoldrArrayImpl)
  (import (only (rnrs base) define lambda)
          (prefix (purs runtime srfi :214) srfi:214:))

  (define unfoldrArrayImpl
    (lambda (isNothing)
      (lambda (fromJust)
        (lambda (fst)
          (lambda (snd)
            (lambda (f)
              (lambda (b)
                (srfi:214:flexvector-unfold
                  (lambda (maybe) (isNothing maybe))
                  (lambda (maybe) (fst (fromJust maybe)))
                  (lambda (maybe) (f (snd (fromJust maybe))))
                  (f b)))))))))
)

