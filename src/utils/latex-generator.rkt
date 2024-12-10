#lang racket

(require racket/string)
(require "../core/problem.rkt")
(provide generate-latex)

; Helper to format constraints for LaTeX
(define (format-constraints constraints)
  (string-join
   (map (λ (constraint)
          (if (regexp-match? #rx"[<>^]" constraint) ; Check if it contains math symbols
              (format "\\item \\( ~a \\)" constraint) ; Wrap in math mode
              (format "\\item ~a" constraint))) ; Keep as plain text
        constraints)
   "\n"))

; Generate LaTeX for a problem
(define (generate-latex problem)
  (format "
\\documentclass[a4paper]{article}
\\usepackage{amsmath}
\\usepackage{amsfonts}
\\usepackage{amssymb}
\\usepackage{hyperref}
\\begin{document}

\\section*{~a}

\\subsection*{Problem Description}
~a

\\subsection*{Constraints}
\\begin{itemize}
  \\item Time Limit: ~a seconds
  \\item Memory Limit: ~a MB
  ~a
\\end{itemize}

\\subsection*{Input Format}
~a

\\subsection*{Output Format}
~a

\\subsection*{Sample Tests}
\\begin{tabular}{|l|l|}
\\hline
\\textbf{Input} & \\textbf{Output} \\\\ \\hline
~a
\\end{tabular}

\\subsection*{Notes}
~a

\\end{document}"
          (problem-name problem)
          (problem-description problem)
          (problem-time-limit problem)
          (problem-memory-limit problem)
          (format-constraints (problem-constraints problem))
          (problem-input-format problem)
          (problem-output-format problem)
          (string-join
           (map (λ (test)
                  (format "~a & ~a \\\\ \\hline"
                          (car test) (cadr test)))
                (problem-sample-tests problem))
           "\n")
          (problem-notes problem)))
