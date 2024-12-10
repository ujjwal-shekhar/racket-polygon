#lang racket

(require "user-code/user-checker.rkt")

(provide display-check-results)

;; Display the check results
(define (display-check-results)
  (println "Checking user solutions...")
  (define results (validate-solutions "user-code/model-solutions/" "user-code/user-solutions/" "user-code/checker-tests/" direct-keep-extra-whitespace))
  (printf "Test Case | User Solution | Verdict\n")
  (printf "----------------------------------\n")
  (for ([(test user) (keys results)])
    (printf "~a | ~a | ~a\n" test user (hash-ref results (cons test user)))))

(module+ main
  (display-check-results))
