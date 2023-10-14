(library (Control.Monad.ST.Uncurried foreign)
  (export
    mkSTFn1
    mkSTFn2
    mkSTFn3
    mkSTFn4
    mkSTFn5
    mkSTFn6
    mkSTFn7
    mkSTFn8
    mkSTFn9
    mkSTFn10
    runSTFn1
    runSTFn2
    runSTFn3
    runSTFn4
    runSTFn5
    runSTFn6
    runSTFn7
    runSTFn8
    runSTFn9
    runSTFn10)

  (import (only (rnrs base) define lambda))

  (define mkSTFn1
    (lambda (fn)
      (lambda (x)
        ((fn x)))))

  (define mkSTFn2
    (lambda (fn)
      (lambda (a b)
        (((fn a) b)))))

  (define mkSTFn3
    (lambda (fn)
      (lambda (a b c)
        ((((fn a) b) c)))))

  (define mkSTFn4
    (lambda (fn)
      (lambda (a b c d)
        (((((fn a) b) c) d)))))

  (define mkSTFn5
    (lambda (fn)
      (lambda (a b c d e)
        ((((((fn a) b) c) d) e)))))

  (define mkSTFn6
    (lambda (fn)
      (lambda (a b c d e f)
        (((((((fn a) b) c) d) e) f)))))

  (define mkSTFn7
    (lambda (fn)
      (lambda (a b c d e f g)
        ((((((((fn a) b) c) d) e) f) g)))))

  (define mkSTFn8
    (lambda (fn)
      (lambda (a b c d e f g h)
        (((((((((fn a) b) c) d) e) f) g) h)))))

  (define mkSTFn9
    (lambda (fn)
      (lambda (a b c d e f g h i)
        ((((((((((fn a) b) c) d) e) f) g) h) i)))))

  (define mkSTFn10
    (lambda (fn)
      (lambda (a b c d e f g h i j)
        (((((((((((fn a) b) c) d) e) f) g) h) i) j)))))

  (define runSTFn1
    (lambda (fn)
      (lambda (a)
        (lambda ()
          (fn a)))))

  (define runSTFn2
    (lambda (fn)
      (lambda (a)
        (lambda (b)
          (lambda ()
            (fn a b))))))

  (define runSTFn3
    (lambda (fn)
      (lambda (a)
        (lambda (b)
          (lambda (c)
            (lambda ()
              (fn a b c)))))))

  (define runSTFn4
    (lambda (fn)
      (lambda (a)
        (lambda (b)
          (lambda (c)
            (lambda (d)
              (lambda ()
                (fn a b c d))))))))

  (define runSTFn5
    (lambda (fn)
      (lambda (a)
        (lambda (b)
          (lambda (c)
            (lambda (d)
              (lambda (e)
                (lambda ()
                  (fn a b c d e)))))))))

  (define runSTFn6
    (lambda (fn)
      (lambda (a)
        (lambda (b)
          (lambda (c)
            (lambda (d)
              (lambda (e)
                (lambda (f)
                  (lambda ()
                    (fn a b c d e f))))))))))

  (define runSTFn7
    (lambda (fn)
      (lambda (a)
        (lambda (b)
          (lambda (c)
            (lambda (d)
              (lambda (e)
                (lambda (f)
                  (lambda (g)
                    (lambda ()
                      (fn a b c d e f g)))))))))))

  (define runSTFn8
    (lambda (fn)
      (lambda (a)
        (lambda (b)
          (lambda (c)
            (lambda (d)
              (lambda (e)
                (lambda (f)
                  (lambda (g)
                    (lambda (h)
                      (lambda ()
                        (fn a b c d e f g h))))))))))))

  (define runSTFn9
    (lambda (fn)
      (lambda (a)
        (lambda (b)
          (lambda (c)
            (lambda (d)
              (lambda (e)
                (lambda (f)
                  (lambda (g)
                    (lambda (h)
                      (lambda (i)
                        (lambda ()
                          (fn a b c d e f g h i)))))))))))))

  (define runSTFn10
    (lambda (fn)
      (lambda (a)
        (lambda (b)
          (lambda (c)
            (lambda (d)
              (lambda (e)
                (lambda (f)
                  (lambda (g)
                    (lambda (h)
                      (lambda (i)
                        (lambda (j)
                          (lambda ()
                            (fn a b c d e f g h i j))))))))))))))
)
