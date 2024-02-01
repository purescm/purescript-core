;; -*- mode: scheme -*-

(library (Effect.Uncurried foreign)
  (export mkEffectFn1
          mkEffectFn2
          mkEffectFn3
          mkEffectFn4
          mkEffectFn5
          mkEffectFn6
          mkEffectFn7
          mkEffectFn8
          mkEffectFn9
          mkEffectFn10
          runEffectFn1
          runEffectFn2
          runEffectFn3
          runEffectFn4
          runEffectFn5
          runEffectFn6
          runEffectFn7
          runEffectFn8
          runEffectFn9
          runEffectFn10)
  (import (only (rnrs base) define lambda))

   (define mkEffectFn1
     (lambda (fn)
       (lambda (x)
         (fn x))))
 
   (define mkEffectFn2
     (lambda (fn)
       (lambda (a b)
         ((fn a) b))))
 
   (define mkEffectFn3
     (lambda (fn)
       (lambda (a b c)
         (((fn a) b) c))))
 
   (define mkEffectFn4
     (lambda (fn)
       (lambda (a b c d)
         ((((fn a) b) c) d))))
 
   (define mkEffectFn5
     (lambda (fn)
       (lambda (a b c d e)
         (((((fn a) b) c) d) e))))
 
   (define mkEffectFn6
     (lambda (fn)
       (lambda (a b c d e f)
         ((((((fn a) b) c) d) e) f))))
 
   (define mkEffectFn7
     (lambda (fn)
       (lambda (a b c d e f g)
         (((((((fn a) b) c) d) e) f) g))))
 
   (define mkEffectFn8
     (lambda (fn)
       (lambda (a b c d e f g h)
         ((((((((fn a) b) c) d) e) f) g) h))))
 
   (define mkEffectFn9
     (lambda (fn)
       (lambda (a b c d e f g h i)
         (((((((((fn a) b) c) d) e) f) g) h) i))))
 
   (define mkEffectFn10
     (lambda (fn)
       (lambda (a b c d e f g h i j)
         ((((((((((fn a) b) c) d) e) f) g) h) i) j))))
 
  (define runEffectFn1
    (lambda (fn)
      (lambda (a)
        (lambda ()
          (fn a)))))

  (define runEffectFn2
    (lambda (fn)
      (lambda (a)
        (lambda (b)
          (lambda ()
            (fn a b))))))

  (define runEffectFn3
    (lambda (fn)
      (lambda (a)
        (lambda (b)
          (lambda (c)
            (lambda ()
              (fn a b c)))))))

  (define runEffectFn4
    (lambda (fn)
      (lambda (a)
        (lambda (b)
          (lambda (c)
            (lambda (d)
              (lambda ()
                (fn a b c d))))))))

  (define runEffectFn5
    (lambda (fn)
      (lambda (a)
        (lambda (b)
          (lambda (c)
            (lambda (d)
              (lambda (e)
                (lambda ()
                  (fn a b c d e)))))))))

  (define runEffectFn6
    (lambda (fn)
      (lambda (a)
        (lambda (b)
          (lambda (c)
            (lambda (d)
              (lambda (e)
                (lambda (f)
                  (lambda ()
                    (fn a b c d e f))))))))))

  (define runEffectFn7
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

  (define runEffectFn8
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

  (define runEffectFn9
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

  (define runEffectFn10
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
