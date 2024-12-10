; #lang racket

; (require racket/system
;          racket/path)

; (provide run-programs-on-inputs)

; ;; Run a Racket program on multiple inputs and store outputs in a directory
; (define (run-programs-on-inputs program-dir input-dir output-dir)
;   ;; Ensure the output directory exists
;   (unless (directory-exists? output-dir)
;     (make-directory output-dir))

;   ; (println "Running programs on inputs...")
;   ; (flush-output) ;; Ensure this message is immediately printed

;   (for ([program (directory-list program-dir)])
;     (for ([input (directory-list input-dir)])
;       ;; Construct the full paths for input and program
;       (define program-path (build-path program-dir (path->string program)))
;       (define input-path (build-path input-dir (path->string input)))

;       ; (println (format "Running ~a on ~a..." (path->string program-path) (path->string input-path)))
;       ; (flush-output) ;; Ensure this message is immediately printed

;       ;; Read the input content from the correct input path
;       (define input-content (file->string input-path))

;       ; (println (format "Input Content: ~a" input-content))

;       (define input-name (substring (path->string input) 0 (- (string-length (path->string input)) 4)))
;       (define program-name (substring (path->string program) 0 (- (string-length (path->string program)) 4)))

;       ; (println (format "Input Name: ~a" input-name))
;       ; (flush-output) ;; Ensure this message is immediately printed

;       ;; Build the output file path
;       ; (define output-file (build-path output-dir (string-append input-name ".out")))
;       (define output-file (build-path output-dir (string-append program-name "-" input-name ".out")))

;       ; (println (format "Output File: ~a" (path->string output-file)))

;       ;; Run the program and store the output
;       (with-output-to-file output-file
;         (lambda ()
;           (parameterize ([current-input-port (open-input-string input-content)])
;             ;; Use the full path of the program
;             (system (format "racket ~a" (path->string program-path))))))

;       ;; Print completion message
;       (printf "Ran ~a on ~a, output saved to ~a\n"
;               (path->string program) input-name (path->string output-file))
;       (flush-output)))) ;; Ensure the completion message is immediately printed

; ; ;; Example usage
; ; (run-programs-on-inputs "../model-dir" "../test-dir" "../output-dir")

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
            (system (format "racket ~a" (path->string program-path))))))

      ;; Print completion message
      (printf "Ran ~a on ~a, output saved to ~a\n"
              (path->string program) test-case-name (path->string output-file))
      (flush-output))))

