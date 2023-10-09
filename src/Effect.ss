;; -*- mode: scheme -*-

(library (Effect foreign)
  (export pureE
          bindE
          untilE
          whileE
          forE
          foreachE)
  (import (only (rnrs base) define lambda quote)
          (only (rnrs arithmetic fixnums) fx+ fx>=?)
          (only (rnrs control) do)
          (prefix (purs runtime srfi :214) srfi:214:))

  (define pureE
    (lambda (a)
      (lambda ()
        a)))

  (define bindE
    (lambda (a)
      (lambda (f)
        (lambda ()
          ((f (a)))))))

  (define untilE
    (lambda (f)
      (lambda ()
        (do () ((f))
          'unit))))

  (define whileE
    (lambda (f)
      (lambda (a)
        (lambda ()
          (do () ((not (f)))
            (a))))))

  (define forE
    (lambda (lo)
      (lambda (hi)
        (lambda (f)
          (lambda ()
            (do ([i lo (fx+ i 1)])
                ((fx>=? i hi) '())
              ((f i))))))))

  (define foreachE
    (lambda (as)
      (lambda (f)
        (lambda ()
          (srfi:214:flexvector-for-each (lambda (x) ((f x))) as)))))

)
