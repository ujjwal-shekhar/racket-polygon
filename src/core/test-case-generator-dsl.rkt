#lang racket

(provide 
  rnd-partition
  rnd-rand-int
  rnd-rand-str
  generate-random-test-case-to-file
  generate-custom-test-case-to-file)

;; Function for partitioning sum_n into test_count parts
(define (rnd-partition test-count sum-n)
  "Partition sum-n into test-count parts."
  (define min-part 1)
  (define raw-sizes (build-list test-count (λ (_) (random 1 sum-n))))  ; Generate random values
  (define sum (apply + raw-sizes))  ; Sum of all parts
  (define adjustment (- sum sum-n))  ; The adjustment needed to make the sum equal to sum-n
  (map (λ (s) (max 1 (- s adjustment))) raw-sizes))  ; Ensure no part is smaller than 1

;; Function to generate a random integer between min and max
(define (rnd-rand-int min max)
  "Generate a random integer between min and max."
  (+ min (random (- max min))))

;; Function to generate a random string of length n
(define (rnd-rand-str n)
  "Generate a random string of length n."
  (apply string (build-list n (λ (_) (integer->char (+ 97 (random 26)))))))

;; Function to generate random test cases and write them to a file
(define (generate-random-test-case-to-file test-count min-a max-a filename print-t-n?)
  "Generate test cases with random values and save to a file."
  (define out (open-output-file filename #:mode 'text #:exists 'replace))

  ;; Print number of test cases only if requested
  (when print-t-n?
    (displayln "T: " out)) ;; You can adjust this output for the number of test cases

  ;; Generate and write each test case to the file
  (for ([i (in-range test-count)])
    ;; Generate two random integers
    (define arr (list (rnd-rand-int min-a max-a) (rnd-rand-int min-a max-a)))
    ;; Write test case header (if needed)
    (when print-t-n?
      (displayln (format "N: ~a" (length arr)) out)) ;; Print the value of N if needed
    ;; Write the integers
    (for-each (λ (elem) (fprintf out "~a " elem)) arr)  ;; Print the integers without brackets
    (newline out))  ;; Newline after each test case

  (close-output-port out))

;; Function to generate custom test cases and write them to a file
(define (generate-custom-test-case-to-file test-count sum-n min-a max-a filename)
  "Generate custom test cases based on user input and save to a file."
  (define lengths (rnd-partition test-count sum-n))

  (define out (open-output-file filename #:mode 'text #:exists 'replace))

  ;; Write number of test cases
  (displayln test-count out)

  ;; Generate and write each test case to the file
  (for-each
   (λ (n)
     (define arr (build-list n (λ (_) (rnd-rand-int min-a max-a))))
     (displayln n out)
     (for-each (λ (elem) (fprintf out "~a " elem)) arr)  ;; Print elements without brackets
     (newline out))  ;; Newline after each test case
   lengths)

  (close-output-port out))
