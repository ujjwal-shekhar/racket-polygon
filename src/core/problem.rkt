#lang racket

(provide problem define-problem)

; Struct for a problem
(struct problem (name description time-limit memory-limit
                      input-format output-format sample-tests notes))

; DSL function for defining problems
(define (define-problem name #:time-limit [time-limit 2]
                        #:memory-limit [memory-limit 256]
                        #:description description
                        #:input-format input-format
                        #:output-format output-format
                        #:sample-tests sample-tests
                        #:notes [notes ""])
  (problem name description time-limit memory-limit
           input-format output-format sample-tests notes))

(provide problem
         problem-name
         problem-description
         problem-time-limit
         problem-memory-limit
         problem-input-format
         problem-output-format
         problem-sample-tests
         problem-notes)
