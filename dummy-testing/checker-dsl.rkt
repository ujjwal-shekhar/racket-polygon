#lang racket

(provide define-checker
         run-checker
         direct-keep-extra-whitespace
         direct-ignore-extra-whitespace)

(require "../utils/program-runner.rkt")

;; DSL Constructs
(define direct-keep-extra-whitespace 'direct-keep-extra-whitespace)
(define direct-ignore-extra-whitespace 'direct-ignore-extra-whitespace)

;; Define the checker
(define-syntax-rule (define-checker name body ...)
  (define (name model-dir user-dir test-dir mode)
    (let ([temp-dir (make-temporary-file #f "temp-output")])
      (parameterize ([current-directory temp-dir])
        (begin body ...)))))

;; Checker logic
(define (run-checker model-dir user-dir test-dir mode)
  (define (compare-outputs model-output user-output mode)
    (define model-lines (file->lines model-output))
    (define user-lines (file->lines user-output))
    (case mode
      [(direct-keep-extra-whitespace)
       (equal? model-lines user-lines)]
      [(direct-ignore-extra-whitespace)
       (let ([strip-ws (lambda (lines) (map string-trim lines))])
         (equal? (strip-ws model-lines) (strip-ws user-lines)))]
      [else
       (error "Unsupported comparison mode")]))

  (define verdicts (make-hasheq))

  ;; Run model and user solutions
  (run-programs-on-inputs model-dir test-dir "model-temp")
  (run-programs-on-inputs user-dir test-dir "user-temp")

  ;; Compare outputs
  (for ([test (directory-list test-dir)]
        [user-solution (directory-list user-dir)])
    (define model-output (build-path "model-temp" (string-append (path->string (path-last test)) ".out")))
    (define user-output (build-path "user-temp" (string-append (path->string (path-last test)) ".out")))

    (hash-set! verdicts
               (cons (path->string (path-last test))
                     (path->string (path-last user-solution)))
               (if (compare-outputs model-output user-output mode) 'AC 'WA)))

  verdicts)
