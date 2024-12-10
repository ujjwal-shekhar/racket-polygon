#lang racket

(require "problem.rkt"
         "../utils/latex-generator.rkt"
         "../utils/pdf-generator.rkt")

(provide create-problem-folder)

; Create the problem folder and generate the PDF
(define (create-problem-folder problem output-path)
  ; Replace spaces in the problem name with underscores for the folder name
  (define problem-folder (string-append output-path "/" (string-replace (problem-name problem) " " "_")))

  ; Create the directory if it doesn't exist
  (unless (directory-exists? problem-folder)
    (make-directory problem-folder))

  ; Generate the LaTeX content
  (define latex-content (generate-latex problem))

  ; Compile LaTeX to PDF
  (compile-latex-to-pdf latex-content problem-folder))
