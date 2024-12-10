#lang racket

(require "src/core/problem-pdf-generate-dsl.rkt"
         "src/core/problem.rkt")

(module+ main
  (define my-problem
    (define-problem "Sum of Two Numbers"
      #:time-limit 1
      #:memory-limit 128
      #:description "Compute the sum of two integers \\(a\\) and \\(b\\)."
      #:input-format "The input consists of two integers \\(a\\) and \\(b\\)."
      #:output-format "Output a single integer representing the sum \\(a + b\\)."
      #:sample-tests '(("1 2" "3") ("5 10" "15"))
      #:constraints '("1 \\leq a, b \\leq 10^9" "a and b are integers")
      #:notes "For example, if \\(a = 1\\) and \\(b = 2\\), the sum is \\(1 + 2 = 3\\)."))
  
  ; Create the folder and generate the PDF
  (create-problem-folder my-problem "./problems"))
