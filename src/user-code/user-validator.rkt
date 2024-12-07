#lang racket

(require "../core/validator-dsl.rkt") ; Adjust path to core

(provide validate-sum-of-two-numbers) ; Export the validator function

(define-validator validate-sum-of-two-numbers
  (setTestCase 1)
  (let ([a (readInt 1 1000000000 "a")]
        [b (readInt 1 1000000000 "b")])
    (ensure (< (+ a b) 2000000000) "Sum exceeds the allowed maximum: ~a" (+ a b))
    (readEoln)
    (readEof)))
