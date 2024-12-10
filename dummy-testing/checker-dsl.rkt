; #lang racket

; (require "utils/program-runner.rkt" ; Import your utility script
;          racket/list
;          racket/path
;          racket/format)

; (provide define-checker compare-outputs)

; ;; Define a checker DSL
; (define-syntax-rule (define-checker name (model-dir user-dir test-dir))
;   (define (name model-dir user-dir test-dir)
;     ;; Create temporary directories for outputs
;     (unless (directory-exists? "tmp-outputs")
;       (make-directory "tmp-outputs"))
;     (define model-output-dir (build-path "tmp-outputs" "model-outputs"))
;     (define user-output-dir (build-path "tmp-outputs" "user-outputs"))

    
;     ;; Run model and user solutions on test cases
;     (run-programs-on-inputs model-dir test-dir model-output-dir)
;     (run-programs-on-inputs user-dir test-dir user-output-dir)
    
;     ;; Compare outputs
;     (compare-outputs model-output-dir user-output-dir test-dir)))

; ;; Compare the outputs and generate a table
; (define (compare-outputs model-output-dir user-output-dir test-dir)
;   (define test-files (directory-list test-dir))
;   (define user-output-files (directory-list user-output-dir))
;   (define model-output-files (directory-list model-output-dir))

;   (println (format "Test files: ~a" test-files))
;   (println (format "User output files: ~a" user-output-files))
;   (println (format "Model output files: ~a" model-output-files))

;   ;; Create table headers
;   (define user-names 
;     (map (lambda (path)
;            (substring (path->string path) 0 (- (string-length (path->string path)) 4)))
;          user-output-files))
;   (define header (cons "Test Case" user-names))

;   (println (format "User names: ~a" user-names))

;   ;; Compare each test case output with the model output
;   (define rows
;     (for/list ([test test-files])
;       (let* ([test-name (substring (path->string test) 0 (- (string-length (path->string test)) 4))]
;              [model-output-file (find-output-file model-output-files "model" test-name)]
;              [row (for/list ([user user-output-files])
;                     (let* ([user-output-file (find-output-file user-output-files (path->string user) test-name)]
;                            [model-output (file->string model-output-file)]
;                            [user-output (file->string user-output-file)])
;                       (if (equal? model-output user-output) "AC" "WA")))])
;         (cons test-name row))))

;   ;; Print table
;   (printf "~a\n" (string-join header "\t"))
;   (for ([row rows])
;     (printf "~a\n" (string-join row "\t"))))

; ;; Helper function to find the output file for a given test case and solution
; (define (find-output-file output-files solution-name test-name)
;   (define prefix (string-append solution-name "-" test-name))
;   (findf (lambda (path) (string-prefix? prefix (path->string path))) output-files))

#lang racket

(require "utils/program-runner.rkt" ; Import updated program-runner
         racket/list
         racket/path
         racket/format)

(provide define-checker compare-outputs)

;; Define a checker DSL
(define-syntax-rule (define-checker name (model-dir user-dir test-dir))
  (define (name model-dir user-dir test-dir)
    ;; Create temporary directories for outputs
    (unless (directory-exists? "tmp-outputs")
      (make-directory "tmp-outputs"))
    (define model-output-dir (build-path "tmp-outputs" "model-outputs"))
    (define user-output-dir (build-path "tmp-outputs" "user-outputs"))

    ;; Run model and user solutions on test cases
    (run-programs-on-inputs model-dir test-dir model-output-dir)
    (run-programs-on-inputs user-dir test-dir user-output-dir)

    ;; Compare outputs
    (compare-outputs model-output-dir user-output-dir test-dir)))

;; Compare the outputs and generate a table
(define (compare-outputs model-output-dir user-output-dir test-dir)
  (define test-files (directory-list test-dir))
  (define user-names (map (lambda (path)
                            (substring (path->string path) 0 (- (string-length (path->string path)) 4)))
                          (directory-list user-output-dir)))

  ;; Create table header
  (define header (cons "Test Case" user-names))

  ;; Compare each test case output with the model output
  (define rows
    (for/list ([test test-files])
      (let* ([test-name (substring (path->string test) 0 (- (string-length (path->string test)) 4))]
             [model-dir (build-path model-output-dir test-name)]
             [user-dir (build-path user-output-dir test-name)]
             [row (for/list ([user user-names])
                    (let ([model-output-file (build-path model-dir "model.out")]
                          [user-output-file (build-path user-dir (string-append user ".out"))])
                      (if (and (file-exists? model-output-file)
                               (file-exists? user-output-file)
                               (equal? (file->string model-output-file) (file->string user-output-file)))
                          "AC"
                          "WA")))])
        (cons test-name row))))

  ;; Print table
  (printf "~a\n" (string-join header "\t"))
  (for ([row rows])
    (printf "~a\n" (string-join row "\t"))))

