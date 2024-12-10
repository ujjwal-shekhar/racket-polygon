#lang racket

(require "../src/core/checker-dsl.rkt")

(provide run-checker)

(define-checker run-checker (model-dir user-dir test-dir))
