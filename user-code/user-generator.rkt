#lang racket
(define (generate-test-case)
  (define a (random 100))
  (define b (random 100))
  (list (format "~a ~a" a b) (format "~a" (+ a b))))
