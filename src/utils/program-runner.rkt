#lang racket

(require racket/system
         racket/path)

(provide run-programs-on-inputs)

;; Run a Racket program on multiple inputs and store outputs in directories per test case
(define (run-programs-on-inputs program-dir input-dir output-dir)
  ;; Ensure the output directory exists
  (unless (directory-exists? output-dir)
    (make-directory output-dir))

  (for ([input (directory-list input-dir)])
    ;; Extract the test case name and ensure a subdirectory exists for it
    (define test-case-name (substring (path->string input) 0 (- (string-length (path->string input)) 4)))
    (define test-output-dir (build-path output-dir test-case-name))
    (unless (directory-exists? test-output-dir)
      (make-directory test-output-dir))

    (for ([program (directory-list program-dir)])
      ;; Construct the full paths for input and program
      (define program-path (build-path program-dir (path->string program)))
      (define input-path (build-path input-dir (path->string input)))

      ;; Read the input content
      (define input-content (file->string input-path))
      (define program-name (substring (path->string program) 0 (- (string-length (path->string program)) 4)))

      ;; Build the output file path
      (define output-file (build-path test-output-dir (string-append program-name ".out")))

      ;; Run the program and store the output
      (with-output-to-file output-file
        (lambda ()
          (parameterize ([current-input-port (open-input-string input-content)])
            (system (format "racket ~a" (path->string program-path)))))))))

