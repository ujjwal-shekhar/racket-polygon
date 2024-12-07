#lang racket

(require racket/sandbox)

(provide define-validator
         readInt
         readInts
         readString
         ensure
         ensureRange
         ensureDistinct
         setTestCase
         readEoln
         readEof
         validate-tests)

;; Define a validator
(define-syntax-rule (define-validator name body ...)
  (define (name test-case)
    (parameterize ([current-input-port (open-input-string test-case)])
      (begin body ...))))

;; DSL Constructs
(define (readInt min max description)
  (let ([value (read)])
    (unless (and (integer? value) (<= min value max))
      (error "Validation error" (format "Expected an integer between ~a and ~a for ~a, but got: ~a" min max description value)))
    value))

(define (readInts count min max description)
  (let ([values (for/list ([i (in-range count)]) (readInt min max description))])
    values))

(define (readString description)
  (let ([value (read-line)])
    (unless (string? value)
      (error "Validation error" (format "Expected a string for ~a, but got: ~a" description value)))
    value))

(define (ensure condition message . args)
  (unless condition
    (error "Validation error" (apply format (string-append message) args))))

(define (ensureRange values min max description)
  (for ([v values])
    (ensure (<= min v max) "~a: Value ~a out of range ~a to ~a" description v min max)))

(define (ensureDistinct values description)
  (unless (= (length values) (length (remove-duplicates values)))
    (error "Validation error" (format "~a: Values are not distinct: ~a" description values))))

(define (setTestCase test-case-id)
  (printf "Running test case ~a...\n" test-case-id))

(define (readEoln)
  (let ([next-char (peek-char)])
    (unless (or (eof-object? next-char) (char=? next-char #\newline))
      (error "Validation error" "Expected end of line but got something else"))))

(define (readEof)
  (unless (eof-object? (peek-char))
    (error "Validation error" "Expected end of file but input is not fully consumed")))

;; Validate tests in a sandbox
(define (validate-tests validator tests)
  (define sandbox (make-evaluator 'racket)) ; Simplified evaluator creation without `#:sandbox-output`
  
  (for ([test tests] 
        [i (in-naturals)]) ; Iterate over each test case
    (setTestCase (+ i 1)) ; Set the test case number
    (parameterize ([current-input-port (open-input-string test)]) ; Set the input port for each test case
      (sandbox (lambda () (validator test)))))) ; Evaluate the validator in the sandbox
