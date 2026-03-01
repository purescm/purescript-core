;; -*- mode: scheme -*-
;; Number formatting to match JavaScript's Number.prototype methods:
;; toPrecision, toFixed, toExponential, and toString.

(library (Data.Number.Format foreign)
  (export toPrecisionNative
          toFixedNative
          toExponentialNative
          toString)
  (import (only (rnrs base) define lambda let let* cond else if and or not
                             string-append number->string string-length string-ref
                             substring char=? max >= <= > < = + - *
                             make-string)
          (only (rnrs arithmetic flonums) fl=? fl<? fl>=? fl/ fl- flfloor fllog
                                          flexpt fixnum->flonum)
          (only (chezscheme) format fixnum? flonum? set! flonum->fixnum)
          (only (purescm pstring) string->pstring))

  ;; ---------------------------------------------------------------
  ;; Internal helpers
  ;; ---------------------------------------------------------------

  ;; Strip trailing dot from a formatted number string.
  ;; "3." -> "3", "3.14" -> "3.14"
  (define (strip-trailing-dot s)
    (let ([len (string-length s)])
      (if (and (> len 0) (char=? (string-ref s (- len 1)) #\.))
        (substring s 0 (- len 1))
        s)))

  ;; Strip trailing zeros (and dot) from a decimal string.
  ;; "3.1400" -> "3.14", "3.00" -> "3", "10" -> "10"
  (define (strip-trailing-zeros s)
    (let ([has-dot (let loop ([i 0])
                     (if (>= i (string-length s)) #f
                       (if (char=? (string-ref s i) #\.) #t
                         (loop (+ i 1)))))])
      (if (not has-dot) s
        (let loop ([end (string-length s)])
          (cond
            [(and (> end 0) (char=? (string-ref s (- end 1)) #\0))
             (loop (- end 1))]
            [(and (> end 0) (char=? (string-ref s (- end 1)) #\.))
             (substring s 0 (- end 1))]
            [else (substring s 0 end)])))))

  ;; Format an exponent as "+N" or "-N"
  (define (format-exp e)
    (if (>= e 0)
      (string-append "+" (number->string e))
      (number->string e)))

  ;; Compute floor(log10(|num|)), adjusted for rounding.
  ;; Returns a fixnum exponent.
  (define (compute-exponent abs-num)
    (let* ([e (flonum->fixnum (flfloor (fl/ (fllog abs-num) (fllog 10.0))))]
           [m (fl/ abs-num (flexpt 10.0 (fixnum->flonum e)))])
      (if (fl>=? m 10.0) (+ e 1) e)))

  ;; ---------------------------------------------------------------
  ;; toExponentialNative(d, num) -> String
  ;; Matches JS Number.prototype.toExponential(d)
  ;; ---------------------------------------------------------------
  (define toExponentialNative
    (lambda (d)
      (lambda (num)
        (string->pstring
          (cond
            [(fl=? num 0.0)
             (if (= d 0) "0e+0"
               (string-append "0." (make-string d #\0) "e+0"))]
            [else
             (let* ([neg (fl<? num 0.0)]
                    [abs-num (if neg (fl- 0.0 num) num)]
                    [exp-val (compute-exponent abs-num)]
                    [mantissa (fl/ abs-num (flexpt 10.0 (fixnum->flonum exp-val)))]
                    [mant-str (strip-trailing-dot
                                (format (string-append "~," (number->string d) "F") mantissa))]
                    [result (string-append mant-str "e" (format-exp exp-val))])
               (if neg (string-append "-" result) result))])))))

  ;; ---------------------------------------------------------------
  ;; toPrecisionNative(d, num) -> String
  ;; Matches JS Number.prototype.toPrecision(d)
  ;; d = number of significant digits (already clamped 1..21 by PureScript)
  ;; ---------------------------------------------------------------
  (define toPrecisionNative
    (lambda (d)
      (lambda (num)
        (string->pstring
          (cond
            [(fl=? num 0.0)
             (if (<= d 1) "0"
               (string-append "0." (make-string (- d 1) #\0)))]
            [else
             (let* ([neg (fl<? num 0.0)]
                    [abs-num (if neg (fl- 0.0 num) num)]
                    [exp-val (compute-exponent abs-num)])
               ;; JS uses exponential when exponent < -6 or exponent >= d
               (if (or (< exp-val -6) (>= exp-val d))
                 ;; Exponential notation with (d-1) decimal places
                 (let* ([mantissa (fl/ abs-num (flexpt 10.0 (fixnum->flonum exp-val)))]
                        [mant-str (strip-trailing-zeros
                                    (strip-trailing-dot
                                      (format (string-append "~," (number->string (- d 1)) "F") mantissa)))]
                        [result (string-append mant-str "e" (format-exp exp-val))])
                   (if neg (string-append "-" result) result))
                 ;; Fixed notation: number of decimal places = d - exponent - 1
                 (let* ([fixed-digits (max 0 (- d exp-val 1))]
                        [fixed-str (strip-trailing-dot
                                     (format (string-append "~," (number->string fixed-digits) "F")
                                             (if neg (fl- 0.0 abs-num) abs-num)))])
                   fixed-str)))])))))

  ;; ---------------------------------------------------------------
  ;; toFixedNative(d, num) -> String
  ;; Matches JS Number.prototype.toFixed(d)
  ;; ---------------------------------------------------------------
  (define toFixedNative
    (lambda (d)
      (lambda (num)
        (string->pstring
          (strip-trailing-dot
            (format (string-append "~," (number->string d) "F") num))))))

  ;; ---------------------------------------------------------------
  ;; toString(num) -> String
  ;; Matches JS Number.prototype.toString()
  ;; ---------------------------------------------------------------
  (define toString
    (lambda (num)
      (string->pstring
        ;; Special case: -0.0 should produce "0" to match JS behavior
        (if (and (flonum? num) (fl=? num 0.0) (fl<? (fl/ 1.0 num) 0.0))
          "0"
          (let* ([s (number->string num)]
                 [len (string-length s)])
            ;; Strip trailing .0 for integer flonums (e.g., "10.0" -> "10")
            (if (and (>= len 2)
                     (char=? (string-ref s (- len 1)) #\0)
                     (char=? (string-ref s (- len 2)) #\.))
              (substring s 0 (- len 2))
              ;; Ensure positive exponents have "+" (e.g., "1e21" -> "1e+21")
              (let loop ([i 0])
                (if (>= i len) s
                  (if (char=? (string-ref s i) #\e)
                    (if (and (< (+ i 1) len)
                             (not (char=? (string-ref s (+ i 1)) #\-))
                             (not (char=? (string-ref s (+ i 1)) #\+)))
                      (string-append (substring s 0 (+ i 1)) "+" (substring s (+ i 1) len))
                      s)
                    (loop (+ i 1)))))))))))

)
