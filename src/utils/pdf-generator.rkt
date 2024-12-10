#lang racket

(require racket/system racket/file racket/path)

(provide compile-latex-to-pdf)

; Compile LaTeX content into a PDF
(define (compile-latex-to-pdf latex-content output-folder)
  (define tex-file (build-path output-folder "problem.tex"))
  (define pdf-file (build-path output-folder "problem.pdf"))

  ; Write LaTeX to a .tex file
  (call-with-output-file tex-file
    (λ (out)
      (fprintf out "~a" latex-content))
    #:exists 'replace)

  ; Call pdflatex to compile the .tex file
  (unless (directory-exists? (string->path output-folder))
    (make-directory (string->path output-folder)))

  (define cmd (format "pdflatex -output-directory ~a ~a"
                      (path->string (string->path output-folder))
                      (path->string tex-file)))

  (system cmd)
  pdf-file)
