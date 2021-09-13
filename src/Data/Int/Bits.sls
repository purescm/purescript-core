;; -*- mode: scheme -*-

(library (Data.Int.Bits foreign)
  (export and
          or
          xor
          shl
          shr
          zshr
          complement)
  (import (only (rnrs base) define lambda error))

  (define and
    (lambda (n1)
      (lambda (n2)
        (error #f "Data.Int.Bits:and not implemented."))))

  (define or
    (lambda (n1)
      (lambda (n2)
        (error #f "Data.Int.Bits:or not implemented."))))

  (define xor
    (lambda (n1)
      (lambda (n2)
        (error #f "Data.Int.Bits:xor not implemented."))))

  (define shl
    (lambda (n1)
      (lambda (n2)
        (error #f "Data.Int.Bits:shl not implemented."))))

  (define shr
    (lambda (n1)
      (lambda (n2)
        (error #f "Data.Int.Bits:shr not implemented."))))

  (define zshr
    (lambda (n1)
      (lambda (n2)
        (error #f "Data.Int.Bits:zshr not implemented."))))

  (define complement
    (lambda (n1)
      (lambda (n2)
        (error #f "Data.Int.Bits:complement not implemented."))))

)
