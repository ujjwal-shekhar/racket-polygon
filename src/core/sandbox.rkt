#lang racket
(require racket/sandbox)

;; Define the allowed functions for the sandbox (can add more based on needs)
(define allowed-functions
  (list
   'random         ;; Allow random number generation
   'list           ;; Allow list manipulation
   '<=             ;; Allow comparisons
   'format         ;; Allow string formatting
   'displayln))    ;; Allow output display

;; Set up the sandbox and allow specific functions
(define sandbox
  (make-sandbox
   (lambda ()
     ;; Allow specific functions in the sandbox
     (for-each (lambda (fn) (allow fn)) allowed-functions))))

;; Function to run user code inside the sandbox
(define (run-in-sandbox user-code)
  (with-sandbox
   (lambda ()
     (eval user-code)) sandbox))

;; Example of how to use the sandbox
(define user-generator-code
  '(define (generate-test-case)
     (list (random 100) (random 100))))

;; Run the user generator code in the sandbox
(run-in-sandbox user-generator-code)
