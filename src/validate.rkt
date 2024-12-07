#lang racket

(require "core/validator-dsl.rkt"        ; Path to core DSL
         "user-code/user-validator.rkt") ; Path to user-defined validator

(provide run-validation)

; Validate problem test cases
(define (run-validation validator tests-path)
  (define (load-tests path)
    (map file->string (directory-list path))) ; Load all test files as strings

  (define tests (load-tests tests-path))
  ;;; (println (list "HIHIH" (file->string (directory-list path))))
  (validate-tests validator tests))

(module+ main
  (printf "Running validator...\n")
  (run-validation validate-sum-of-two-numbers "src/user-code/tests")) ; Reference the validator
