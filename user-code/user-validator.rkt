#lang racket

(require "../src/core/validator-dsl.rkt")

(define-validator validate-sum-of-two-numbers
  (let ([a (readInt 1 1000000000 "a")]
        [b (readInt 1 1000000000 "b")])
    (ensure (< (+ a b) 2000000000) "Sum exceeds the allowed maximum: ~a" (+ a b))
    (readEoln)
    (readEof)))

(provide validate-sum-of-two-numbers)