#lang racket

(require "../utils/program-runner.rkt" ; Import updated program-runner
         racket/list
         racket/path
         racket/format
         racket/file)

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
    (compare-outputs model-output-dir user-output-dir test-dir user-dir)

    ;; Cleanup: Delete tmp-outputs directory
    (when (directory-exists? "tmp-outputs")
      (delete-directory/files "tmp-outputs"))))

;; Compare the outputs and generate a formatted table
(define (compare-outputs model-output-dir user-output-dir test-dir user-input-dir)
  (define test-files (directory-list test-dir))
  (define user-names (map (lambda (path)
                            (substring (path->string path) 0 (- (string-length (path->string path)) 4)))
                          (directory-list user-input-dir)))

  ;; Create table header
  (define header (cons "Test Case" user-names))

  ;; Compare each test case output with the model output
  (define rows
    (for/list ([test test-files])
      (let* ([test-name (substring (path->string test) 0 (- (string-length (path->string test)) 4))]
             [model-dir (build-path model-output-dir test-name)]
             [user-dir (build-path user-output-dir test-name)]
             [row (for/list ([user user-names])
                    (let ([model-output-file (build-path model-dir "model-solution.out")]
                          [user-output-file (build-path user-dir (string-append user ".out"))])
                      (if (and (file-exists? model-output-file)
                               (file-exists? user-output-file)
                               (equal? (file->string model-output-file) (file->string user-output-file)))
                          "AC"
                          "WA")))])                
        (cons test-name row))))

  ;; Helper function to pad strings to a specific width
  (define (pad-string str width)
    (define str-len (string-length str))
    (if (>= str-len width)
        str
        (string-append str (make-string (- width str-len) #\space))))

  ;; Determine column widths
  (define col-widths
    (let ([all-rows (cons header rows)])
      (map (lambda (col)
            (apply max (map string-length col)))
          (apply map list all-rows)))) ; Transpose rows to columns

  ;; Function to format a row based on column widths
  (define (format-row row)
    (string-join
    (map (lambda (entry width)
            (pad-string entry width))
          row col-widths)
    " | "))

  ;; Print the table
  (printf "~a\n" (format-row header))
  (printf "~a\n" (make-string (apply + (map add1 col-widths)) #\=)) ; Divider
  (for ([row rows])
    (printf "~a\n" (format-row row))))


; #lang racket

; (require "../utils/program-runner.rkt" ; Import updated program-runner
;          racket/list
;          racket/path
;          racket/format
;          racket/file)

; (provide define-checker compare-outputs)

; ;; Define ANSI escape codes for colors
; (define green "\033[32m") ; Green color
; (define red "\033[31m")   ; Red color
; (define reset "\033[0m")  ; Reset color

; ;; Function to colorize text
; (define (colorize text color)
;   (string-append color text reset))

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
;     (compare-outputs model-output-dir user-output-dir test-dir user-dir)

;     ;; Cleanup: Delete tmp-outputs directory
;     (when (directory-exists? "tmp-outputs")
;       (delete-directory/files "tmp-outputs"))))

; ;; Compare the outputs and generate a formatted table
; (define (compare-outputs model-output-dir user-output-dir test-dir user-input-dir)
;   (define test-files (directory-list test-dir))
;   (define user-names (map (lambda (path)
;                             (substring (path->string path) 0 (- (string-length (path->string path)) 4)))
;                           (directory-list user-input-dir)))

;   ;; Create table header
;   (define header (cons "Test Case" user-names))

;   ;; Compare each test case output with the model output
;   (define rows
;     (for/list ([test test-files])
;       (let* ([test-name (substring (path->string test) 0 (- (string-length (path->string test)) 4))]
;              [model-dir (build-path model-output-dir test-name)]
;              [user-dir (build-path user-output-dir test-name)]
;              [row (for/list ([user user-names])
;                     (let ([model-output-file (build-path model-dir "model-solution.out")]
;                           [user-output-file (build-path user-dir (string-append user ".out"))])
;                       (if (and (file-exists? model-output-file)
;                                (file-exists? user-output-file)
;                                (equal? (file->string model-output-file) (file->string user-output-file)))
;                           (colorize "AC" green) ; AC in green
;                           (colorize "WA" red))))]) ; WA in red                
;         (cons test-name row))))

;   ;; Helper function to pad strings to a specific width
;   (define (pad-string str width)
;     (define str-len (string-length (regexp-replace #rx"\e[[0-9;]*m" str ""))) ; Ignore ANSI codes for length
;     (if (>= str-len width)
;         str
;         (string-append str (make-string (- width str-len) #\space))))

;   ;; Determine column widths
;   (define col-widths
;     (let ([all-rows (cons header rows)])
;       (map (lambda (col)
;              (apply max (map (lambda (str)
;                                (string-length (regexp-replace #rx"\e[[0-9;]*m" str ""))) ; Ignore ANSI codes
;                              col)))
;            (apply map list all-rows)))) ; Transpose rows to columns

;   ;; Function to format a row based on column widths
;   (define (format-row row)
;     (string-join
;      (map (lambda (entry width)
;             (pad-string entry width))
;           row col-widths)
;      " | "))

;   ;; Print the table
;   (printf "~a\n" (format-row header))
;   (printf "~a\n" (make-string (apply + (map add1 col-widths)) #\=)) ; Divider
;   (for ([row rows])
;     (printf "~a\n" (format-row row))))
