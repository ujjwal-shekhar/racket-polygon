#lang racket

(require "user-code/user-generator.rkt") ;; Import the user-generator file

;; Ensure the output folder exists
(define (ensure-folder-exists folder)
  (unless (directory-exists? folder)
    (make-directory folder)))

;; Write a single test case to a file (with each number on a new line)
(define (write-test-case-to-file test-case filename print-t-n?)
  (call-with-output-file filename
    (lambda (out)
      (parameterize ([current-output-port out])
        (when print-t-n?
          (printf "~a\n" (length test-case))) ;; Print T or N if requested
        (for-each (lambda (value) (printf "~a\n" value)) test-case))) ;; Print each value on a new line
    #:exists 'replace))

;; Generate test cases and save them to individual files
(define (generate-tests-to-files)
  (ensure-folder-exists output-folder)
  (define test-cases (generate-tests)) ;; Fetch test cases from `user-generator.rkt`
  (for ([i (in-range (length test-cases))]
        [test-case test-cases])
    (define filename (string-append output-folder "gen_" (number->string (+ i 1)) ".txt"))
    (write-test-case-to-file test-case filename print-t-n?)))

;; Run the test case generation process
(generate-tests-to-files)
