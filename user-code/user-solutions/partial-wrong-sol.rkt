#lang racket

(provide add-two-numbers)

;; Function to read two numbers, add them, and print the result
(define (add-two-numbers)
  (let* ([num1 (string->number (read-line))]
         [num2 (string->number (read-line))]
         [result (+ num1 num2)])
    (if (> result 1000)
        (printf "0\n")
        (printf "~a\n" result))))

;; Run the function when this program is executed
(add-two-numbers)