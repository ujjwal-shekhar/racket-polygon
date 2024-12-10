#lang racket

(require racket/system
         racket/path)

(provide run-programs-on-inputs)

;; Run a Racket program on multiple inputs and store outputs in a directory
(define (run-programs-on-inputs program-dir input-dir output-dir)
  ;; Ensure the output directory exists
  (unless (directory-exists? output-dir)
    (make-directory output-dir))

  (println "Running programs on inputs...")

  (for ([program (directory-list program-dir)]
        [input (directory-list input-dir)])

    ; (println (format "Running ~a on ~a..." (path->string program) (path->string input)))
    ;; Print value of input and program
    ; (println (format "Input: ~a" input))
    ;; Read the input content
    (define input-content (file->string input))
    ;; Extract the input file's name using split-path
    (define-values (base-name _ext) (split-path input))
    (define input-name (path->string base-name))
    ;; Build the output file path
    (define output-file (build-path output-dir (string-append input-name ".out")))

    ;; Run the program and store the output
    (with-output-to-file output-file
      (lambda ()
        (parameterize ([current-input-port (open-input-string input-content)])
          (system (format "racket ~a" program)))))

    (printf "Ran ~a on ~a, output saved to ~a\n"
            (path->string program) input-name (path->string output-file))))


(run-programs-on-inputs "../../user-code/model-solutions/"
                        "../../user-code/checker-tests/"
                        "model-temp")
