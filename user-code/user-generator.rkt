#lang racket

(require "../src/core/test-case-generator-dsl.rkt")

(provide generate-tests)
(provide output-folder)
(provide print-t-n?)

;; User-defined parameters for test case generation
(define test-count 10)            ;; Number of test cases to generate
(define min-a 1)                  ;; Minimum value for a random number
(define max-a 100000)             ;; Maximum value for a random number
(define output-folder "user-code/tests/") ;; Output folder for test cases
(define print-t-n? #f)            ;; Whether to include T and N in the output files

;; Function to generate test cases (using the DSL)
(define (generate-tests)
  ;; Generate random test cases and return them as a list of lists
  (for/list ([i (in-range test-count)])
    (list (rnd-rand-int min-a max-a) (rnd-rand-int min-a max-a))))
