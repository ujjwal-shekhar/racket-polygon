#lang racket

; (require "../src/core/checker-dsl.rkt")

; (define-checker validate-solutions
;   (define verdicts (run-checker model-dir user-dir test-dir mode))
;   (printf "Verdicts:\n")
;   (for ([test (keys verdicts)])
;     (printf "~a: ~a\n" test (hash-ref verdicts test))))

; (provide validate-solutions)

(require "checker-dsl.rkt")

(define-checker run-checker (model-dir user-dir test-dir))
(run-checker "model-dir" "user-dir" "test-dir")
