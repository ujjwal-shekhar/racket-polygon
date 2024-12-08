#lang racket

(require "../src/core/test-case-generator-dsl.rkt")

;; Set parameters for test case generation
(define test-count 1)  ;; Can change this to any number for multi-test cases
(define min-a 1)
(define max-a 100000)
(define filename "user-code/tests/generated-test-cases.txt")
(define print-t-n? #f)  ;; Set to #t to print T and N, #f to skip them

;; Generate test cases and write to the file
(generate-random-test-case-to-file test-count min-a max-a filename print-t-n?)
