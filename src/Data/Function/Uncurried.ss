#!r6rs
#!chezscheme

(library (Data.Function.Uncurried foreign)
  (export
    mkFn0
    mkFn2
    mkFn3
    mkFn4
    mkFn5
    mkFn6
    mkFn7
    mkFn8
    mkFn9
    mkFn10
    runFn0
    runFn2
    runFn3
    runFn4
    runFn5
    runFn6
    runFn7
    runFn8
    runFn9
    runFn10
    )
  (import (prefix (chezscheme) scm:))

  (scm:define mkFn0
    (scm:lambda (fn)
      (scm:lambda ()
        (fn (scm:quote Data.Unit:unit-NOT-DEFINED))))))

  (scm:define mkFn2
    (scm:lambda (fn)
      (scm:lambda (a)
        (scm:lambda (b)
          ((fn a) b)))))

  (scm:define mkFn3
    (scm:lambda (fn)
      (scm:lambda (a)
        (scm:lambda (b)
          (scm:lambda (c)
            (((fn a) b) c))))))

  (scm:define mkFn4
    (scm:lambda (fn)
      (scm:lambda (a)
        (scm:lambda (b)
          (scm:lambda (c)
            (scm:lambda (d)
              ((((fn a) b) c) d)))))))

  (scm:define mkFn5
    (scm:lambda (fn)
      (scm:lambda (a)
        (scm:lambda (b)
          (scm:lambda (c)
            (scm:lambda (d)
              (scm:lambda (e)
                (((((fn a) b) c) d) e))))))))

  (scm:define mkFn6
    (scm:lambda (fn)
      (scm:lambda (a)
        (scm:lambda (b)
          (scm:lambda (c)
            (scm:lambda (d)
              (scm:lambda (e)
                (scm:lambda (f)
                  ((((((fn a) b) c) d) e) f)))))))))

  (scm:define mkFn7
    (scm:lambda (fn)
      (scm:lambda (a)
        (scm:lambda (b)
          (scm:lambda (c)
            (scm:lambda (d)
              (scm:lambda (e)
                (scm:lambda (f)
                  (scm:lambda (g)
                    (((((((fn a) b) c) d) e) f) g))))))))))

  (scm:define mkFn8
    (scm:lambda (fn)
      (scm:lambda (a)
        (scm:lambda (b)
          (scm:lambda (c)
            (scm:lambda (d)
              (scm:lambda (e)
                (scm:lambda (f)
                  (scm:lambda (g)
                    (scm:lambda (h)
                      ((((((((fn a) b) c) d) e) f) g) h)))))))))))

  (scm:define mkFn9
    (scm:lambda (fn)
      (scm:lambda (a)
        (scm:lambda (b)
          (scm:lambda (c)
            (scm:lambda (d)
              (scm:lambda (e)
                (scm:lambda (f)
                  (scm:lambda (g)
                    (scm:lambda (h)
                      (scm:lambda (i)
                        (((((((((fn a) b) c) d) e) f) g) h) i))))))))))))

  (scm:define mkFn10
    (scm:lambda (fn)
      (scm:lambda (a)
        (scm:lambda (b)
          (scm:lambda (c)
            (scm:lambda (d)
              (scm:lambda (e)
                (scm:lambda (f)
                  (scm:lambda (g)
                    (scm:lambda (h)
                      (scm:lambda (i)
                        (scm:lambda (j)
                          ((((((((((fn a) b) c) d) e) f) g) h) i) j)))))))))))))

  (scm:define runFn0
    (scm:lambda (fn)
      (scm:lambda ()
        (fn (scm:quote Data.Unit:unit-NOT-DEFINED)))))

  (scm:define runFn1
    (scm:lambda (fn)
      (scm:lambda (a)
        (fn a))))

  (scm:define runFn2
    (scm:lambda (fn)
      (scm:lambda (a b)
        ((fn a) b))))

  (scm:define runFn3
    (scm:lambda (fn)
      (scm:lambda (a b c)
        (((fn a) b) c))))

  (scm:define runFn4
    (scm:lambda (fn)
      (scm:lambda (a b c d)
        ((((fn a) b) c) d))))

  (scm:define runFn5
    (scm:lambda (fn)
      (scm:lambda (a b c d e)
        (((((fn a) b) c) d) e))))

  (scm:define runFn6
    (scm:lambda (fn)
      (scm:lambda (a b c d e f)
        ((((((fn a) b) c) d) e) f))))

  (scm:define runFn7
    (scm:lambda (fn)
      (scm:lambda (a b c d e f g)
        (((((((fn a) b) c) d) e) f) g))))

  (scm:define runFn8
    (scm:lambda (fn)
      (scm:lambda (a b c d e f g h)
        ((((((((fn a) b) c) d) e) f) g) h))))

  (scm:define runFn9
    (scm:lambda (fn)
      (scm:lambda (a b c d e f g h i)
        (((((((((fn a) b) c) d) e) f) g) h) i))))

  (scm:define runFn10
    (scm:lambda (fn)
      (scm:lambda (a b c d e f g h i j)
        ((((((((((fn a) b) c) d) e) f) g) h) i) j)))))
