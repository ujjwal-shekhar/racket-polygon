#lang racket
(define (check-test-case test-case)
  (let ((a (car test-case))
        (b (cadr test-case)))
    (and (<= 1 a 100)
         (<= 1 b 100))))
