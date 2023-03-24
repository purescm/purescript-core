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
          mkEffectFn10)
  (import (only (rnrs base) define lambda error))

  (define mkEffectFn1
    (lambda (fn)
      (lambda (x)
        (error #f "Effect.Uncurried:mkEffectFn1"))))

  (define mkEffectFn2
    (lambda (fn)
      (lambda (a b)
        (error #f "Effect.Uncurried:mkEffectFn2"))))

  (define mkEffectFn3
    (lambda (fn)
      (lambda (a b c)
        (error #f "Effect.Uncurried:mkEffectFn3"))))

  (define mkEffectFn4
    (lambda (fn)
      (lambda (a b c d)
        (error #f "Effect.Uncurried:mkEffectFn4"))))

  (define mkEffectFn5
    (lambda (fn)
      (lambda (a b c d e)
        (error #f "Effect.Uncurried:mkEffectFn5"))))

  (define mkEffectFn6
    (lambda (fn)
      (lambda (a b c d e f)
        (error #f "Effect.Uncurried:mkEffectFn6"))))

  (define mkEffectFn7
    (lambda (fn)
      (lambda (a b c d e f g)
        (error #f "Effect.Uncurried:mkEffectFn7"))))

  (define mkEffectFn8
    (lambda (fn)
      (lambda (a b c d e f g h)
        (error #f "Effect.Uncurried:mkEffectFn8"))))

  (define mkEffectFn9
    (lambda (fn)
      (lambda (a b c d e f g h i)
        (error #f "Effect.Uncurried:mkEffectFn9"))))

  (define mkEffectFn10
    (lambda (fn)
      (lambda (a b c d e f g h i j)
        (error #f "Effect.Uncurried:mkEffectFn10"))))

)
