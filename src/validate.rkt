#lang racket

(require "core/validator-dsl.rkt"        ; Path to core DSL
         "user-code/user-validator.rkt") ; Path to user-defined validator

(provide run-validation)

; Validate problem test cases
(define (run-validation validator tests-path)
  (define (absolute-paths dir)
    (map (lambda (p) (build-path dir p))
        (directory-list dir)))
  (define (load-tests path)
    (map file->string (absolute-paths path))) ; Load all test files as strings

  (define tests (load-tests tests-path))
  (validate-tests validator tests))

(module+ main
  (printf "Running validator...\n")
  (run-validation validate-sum-of-two-numbers "src/user-code/tests")) ; Reference the validator
