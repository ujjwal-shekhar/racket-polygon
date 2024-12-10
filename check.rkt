#lang racket

(require "user-code/user-checker.rkt")

(provide display-check-results)

;; Display the check results
(define (display-check-results)
  (run-checker "user-code/model-solutions" "user-code/user-solutions" "user-code/checker-tests"))

(module+ main
  (display-check-results))
