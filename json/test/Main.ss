(library (Test.JSON.Main foreign)
  (export testJsonParser)
  (import (chezscheme)
          (prefix (purs runtime) rt:)
          (prefix (purs runtime srfi :214) srfi:214:)
          (purs runtime pstring)
          (only (JSON.Internal foreign) json-parse json-stringify))

  (define (assert-parsed input expected)
    (let ([actual (json-parse (string->pstring input))])
      (when (not (pstring=? actual (string->pstring expected)))
        (error #f (format "Expected ~s, got ~s" expected (pstring->string actual))))))

  (define (assert-roundtrip input expected)
    (let* ([actual (json-parse (string->pstring input))]
           [actual-str (json-stringify actual)])
      (when (not (pstring=? actual-str (string->pstring expected)))
        (error #f (format "Expected ~s, got ~s" expected (pstring->string actual-str))))))

  (define check-raises
    (case-lambda
      [(thunk msg)
       (let ([res (call/cc
                     (lambda (k)
                       (with-exception-handler
                         (lambda (e) (k e))
                         (lambda () (begin (thunk) #f)))))])
          (if (not res)
            (error #f "Expected to fail but did not")
            (when (not (string=? msg (condition-message res)))
              (error #f (format "Expected to fail with message ~s, but got ~s" msg (condition-message res))))))]
      [(thunk)
        (let ([res (call/cc
                     (lambda (k)
                       (with-exception-handler
                         (lambda (e) (k #t))
                         (lambda () (begin (thunk) #f)))))])
          (if (not res) (error #f "Expected to fail but did not")))]))

  (define assert-fail
    (case-lambda
      [(input msg) (check-raises (lambda () (json-parse (string->pstring input))) msg)]
      [(input) (check-raises (lambda () (json-parse (string->pstring input))))]))

  (define testJsonParser
    (lambda ()
      (display "  Strings\n")
      (assert-roundtrip "\"foo\"" "\"foo\"")

      (assert-roundtrip "\"\\n\"" "\"\\n\"")
      (assert-roundtrip "\"\\n\\t\\r\"" "\"\\n\\t\\r\"")
      (assert-roundtrip "\"bar\\n\"" "\"bar\\n\"")
      (assert-roundtrip "\"\\nbar\"" "\"\\nbar\"")

      (display "  Invalid strings with control chars\n")
      (assert-fail "\"\n\"" "Invalid control character in string")
      (assert-fail "\"\r\"" "Invalid control character in string")
      (assert-fail "\"foo\n\"" "Invalid control character in string")
      (assert-fail "\"\\z\"" "Invalid string escape z")

      (display "  Unicode escapes\n")
      (assert-fail "\"\\u03\"")
      (assert-roundtrip "\"\\u03BB\"" "\"λ\"")
      (assert-roundtrip "\"foo \\u03BB \\u03bc\"" "\"foo λ μ\"")
      (assert-fail "\"\\u03z\"" "Unexpected token 'z', was expecting a hex digit")
      (assert-fail "\"\\u03" "Unexpected end of input, was expecting a hex digit")
      ; surrogate pairs
      (assert-roundtrip "\"\\uD801\\uDC37\"" "\"𐐷\"")
      (assert-roundtrip "\" \\uD801\\uDC37 foo\"" "\" 𐐷 foo\"")
      (assert-fail "\"\\uD801 \"" "Unexpected ' ', was expecting '\\'")
      (assert-fail "\"\\uDC37 \"" "Invalid unicode escape DC37")

      (display "  Leading whitespace\n")
      (assert-roundtrip "\n\r  \"\\nbar\"" "\"\\nbar\"")

      (display "  Numbers\n")
      (assert-roundtrip " 0 " "0")
      (assert-roundtrip "2" "2")
      (assert-roundtrip "-2" "-2")
      (assert-roundtrip "-123" "-123")
      (assert-roundtrip "42" "42")
      (assert-roundtrip "402" "402")
      (assert-roundtrip " 777777777777777777777777 " "777777777777777777777777")
      (assert-roundtrip " -777777777777777777777777 " "-777777777777777777777777")
      (assert-roundtrip "1.1" "1.1")
      (assert-roundtrip "1.10" "1.1")
      (assert-roundtrip "99999.99" "99999.99")
      (assert-roundtrip "0.123" "0.123")
      (assert-roundtrip "0.33333" "0.33333")
      (assert-roundtrip "0.00" "0")
      (assert-roundtrip "-0.00" "0")
      (assert-roundtrip "0.01" "0.01")
      (assert-roundtrip "-0.01" "-0.01")
      (assert-roundtrip "12.34e10" "123400000000")
      (assert-roundtrip "12e10" "120000000000")
      (assert-roundtrip "12e+10" "120000000000")
      (assert-roundtrip "12e01" "120")
      (assert-roundtrip "1e-53" "1e-53")
      (assert-roundtrip "1.10e30" "1100000000000000000000000000000")
      (assert-fail "0." "Unexpected end of number, was expecting a fraction")
      (assert-fail "01" "Unexpected token '1'")
      (assert-fail "1ee1" "Unexpected token 'e'")
      (assert-fail "1x1" "Unexpected token 'x'")

      (display "  Booleans\n")
      (assert-roundtrip "true" "true")
      (assert-roundtrip "false" "false")
      (assert-roundtrip " true " "true")
      (assert-roundtrip " false " "false")
      (assert-fail " f")
      (assert-fail " fals")
      (assert-fail " t")
      (assert-fail " tru")

      (display "  null\n")
      (assert-roundtrip "null" "null")
      (assert-roundtrip " null " "null")
      (assert-fail " n")
      (assert-fail " nul")

      (display "  Arrays\n")
      (assert-roundtrip "[]" "[]")
      (assert-roundtrip "[  ]" "[]")
      (assert-roundtrip "[\"foo\"]" "[\"foo\"]")
      (assert-roundtrip "[\"foo\",\"bar\" ]" "[\"foo\",\"bar\"]")
      (assert-roundtrip " [  \"foo\" ,  \"bar\"  ]" "[\"foo\",\"bar\"]")
      (assert-roundtrip " [  \"foo\" ,  \"bar\", \"baz\"  ]" "[\"foo\",\"bar\",\"baz\"]")
      (assert-roundtrip " [ \"foo\", true, false ]" "[\"foo\",true,false]")
      (assert-fail "[,]" "Unexpected token ','")
      (assert-fail "[,,]" "Unexpected token ','")
      (assert-fail "[\"foo\",]" "Unexpected token ']'")
      (assert-fail "[ , \"foo\"]" "Unexpected token ','")

      (display "  Objects\n")
      (assert-roundtrip "{}" "{}")
      (assert-roundtrip "{ }" "{}")
      (assert-roundtrip "{ \"key\":\"value\"}" "{\"key\":\"value\"}")
      (assert-roundtrip "{ \"key\" : \"value\" }" "{\"key\":\"value\"}")
      (assert-roundtrip "{ \"key\":\"value\",\"key2\":\"value2\"}" "{\"key\":\"value\",\"key2\":\"value2\"}")
      (assert-roundtrip "{ \"key\":\"value\",\"key2\":\"value2\",\"key3\":\"value3\"}" "{\"key\":\"value\",\"key2\":\"value2\",\"key3\":\"value3\"}")
      (assert-fail "{,}")
      (assert-fail "{\"foo\",}")
      (assert-fail "{, \"foo\"}" "Unexpected ',', was expecting '\"'")
      (assert-fail "{\"foo\" : }")

      (display "  Nested\n")
      (assert-roundtrip "{ \"array\":[ null, true, false ], \"obj\": { \"key\" : \"value\" }}" "{\"array\":[null,true,false],\"obj\":{\"key\":\"value\"}}")

      (display "  Trailing token\n")
      (assert-fail "0 0" "Unexpected token '0'")
      (assert-fail "{} 0" "Unexpected token '0'")
      (assert-fail "[] []" "Unexpected token '['")
      (assert-fail "[][]" "Unexpected token '['")

      ))

  )

