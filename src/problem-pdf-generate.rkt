#lang racket

(require "core/problem.rkt"
         "core/latex-generator.rkt"
         "core/pdf-generator.rkt")

(provide create-problem-folder)

; Create the problem folder and generate the PDF
(define (create-problem-folder problem output-path)
  ; Replace spaces in the problem name with underscores for the folder name
  (define problem-folder (string-append output-path "/" (string-replace (problem-name problem) " " "_")))

  ; Create the directory if it doesn't exist
  (unless (directory-exists? problem-folder)
    (make-directory problem-folder))

  ; Generate the LaTeX content
  (define latex-content (generate-latex problem))

  ; Compile LaTeX to PDF
  (compile-latex-to-pdf latex-content problem-folder))

; Example usage
(module+ main
  (define my-problem
    (define-problem "Sum of Two Numbers"
      #:time-limit 1
      #:memory-limit 128
      #:description "Compute the sum of two integers \\(a\\) and \\(b\\)."
      #:input-format "The input consists of two integers \\(a\\) and \\(b\\)."
      #:output-format "Output a single integer representing the sum \\(a + b\\)."
      #:sample-tests '(("1 2" "3") ("5 10" "15"))
      #:notes "Ensure the inputs satisfy \\(1 \\leq a, b \\leq 10^9\\)."))
  
  ; Create the folder and generate the PDF
  (create-problem-folder my-problem "./problems"))
