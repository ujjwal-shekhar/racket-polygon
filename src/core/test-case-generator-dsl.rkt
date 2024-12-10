#lang racket

(provide 
  rnd-partition
  rnd-rand-int
  rnd-rand-str
  generate-random-test-case-to-file
  generate-custom-test-case-to-file
  rnd-tree
  rnd-weighted-tree
  rnd-graph
  write-edges-to-file
  rnd-bipartite-graph
  write-bipartite-graph-to-file
  random-weighted)

;; Function for partitioning sum_n into test_count parts
(define (rnd-partition test-count sum-n)
  "Partition sum-n into test-count parts."
  (define min-part 1)
  (define raw-sizes (build-list test-count (λ (_) (random 1 sum-n))))  ; Generate random values
  (define sum (apply + raw-sizes))  ; Sum of all parts
  (define adjustment (- sum sum-n))  ; The adjustment needed to make the sum equal to sum-n
  (map (λ (s) (max 1 (- s adjustment))) raw-sizes))  ; Ensure no part is smaller than 1

;; Function to generate a random integer between min and max
(define (rnd-rand-int min max)
  "Generate a random integer between min and max."
  (+ min (random (- max min))))

;; Function to generate a random string of length n
(define (rnd-rand-str n)
  "Generate a random string of length n."
  (apply string (build-list n (λ (_) (integer->char (+ 97 (random 26)))))))

;; Function to generate a random permutation of integers from 1 to n
(define (rnd-permutation n)
  "Generate a random permutation of integers from 1 to n."
  (define arr (build-list n (λ (i) (+ i 1)))) ; Create a list [1, 2, ..., n]
  (shuffle arr)) ; Shuffle the list randomly

;; Function to generate a random tree as a list of edges
(define (rnd-tree n)
  "Generate a random tree represented as a list of edges."
  (define parent (build-list n (λ (i) (if (= i 0) 0 (random i)))))
  (shuffle (for/list ([i (in-range 1 n)]) (list (add1 i) (add1 (list-ref parent i))))))

;; Function to generate a weighted random tree
(define (rnd-weighted-tree n t)
  "Generate a weighted tree using a weighted random attachment rule."
  (define parent (build-list n (λ (i) (if (= i 0) 0 (random-weighted i t)))))
  (shuffle (for/list ([i (in-range 1 n)]) (list (add1 i) (add1 (list-ref parent i))))))

;; Helper function for weighted random selection
(define (random-weighted size t)
  "Select an index with a weighted random probability influenced by t."
  (define weights (build-list size (λ (i) (expt (+ i 1) t)))) ; Weight each index
  (define sum-weights (apply + weights)) ; Total sum of weights
  (define rnd (random sum-weights)) ; Random number in range
  (for ([i (in-range size)])
    (set! rnd (- rnd (list-ref weights i)))
    (when (< rnd 0) (values i)))) ; Use values to return the selected index

;; Function to generate a random connected graph
(define (rnd-graph n m)
  "Generate a random connected graph with n nodes and m edges."
  (define edges (set)) ; Store edges in a set to avoid duplicates
  ;; Generate a tree first to ensure the graph is connected
  (define tree-edges (rnd-tree n))
  (for ([e tree-edges]) (set-add! edges e))
  ;; Add random edges to meet the desired edge count
  (for ([i (in-range (- m (- n 1)))])
    (define u (+ 1 (random n)))
    (define v (+ 1 (random n)))
    (when (and (not (= u v)) (not (set-member? edges (list u v))) (not (set-member? edges (list v u))))
      (set-add! edges (list u v))))
  (shuffle (set->list edges)))

;; Function to generate a random bipartite graph
(define (rnd-bipartite-graph n m k t)
  "Generate a random bipartite graph with n nodes in set A, m nodes in set B, and k edges."
  ;; Recursive helper to generate k unique edges
  (define (generate-edges edges count)
    (if (= count 0)
        (set->list edges)  ; Convert the set of edges to a list when done
        (let* ([a (random-weighted n t)]  ; Randomly select a node from set A
               [b (random-weighted m t)]  ; Randomly select a node from set B
               [new-edge (list a b)])     ; Create a new edge
          (if (set-member? edges new-edge)
              (generate-edges edges count)  ; If the edge exists, try again
              (generate-edges (set-add edges new-edge) (- count 1)))))) ; Add edge and decrement count

  ;; Generate edges
  (define edges (generate-edges (set) k))

  ;; Generate permutations for nodes in sets A and B
  (define pa (shuffle (build-list n (λ (i) (+ i 1)))))
  (define pb (shuffle (build-list m (λ (i) (+ i 1)))))

  ;; Map edges to the permuted node labels
  (define mapped-edges
    (map (λ (edge)
           (list (list-ref pa (first edge)) (list-ref pb (second edge))))
         edges))

  (values pa pb mapped-edges))  ; Return the permutations and edges using `values`

;; Function to write edges to a file
(define (write-edges-to-file edges filename)
  "Write a list of edges to a file."
  (define out (open-output-file filename #:mode 'text #:exists 'replace))
  (displayln (length edges) out) ; Write the number of edges
  (for ([edge edges]) (fprintf out "~a ~a\n" (first edge) (second edge))) ; Write each edge
  (close-output-port out))

;; Function to write a bipartite graph to a file
(define (write-bipartite-graph-to-file filename n m k t)
  "Generate and write a bipartite graph to a file."
  (define out (open-output-file filename #:mode 'text #:exists 'replace))

  ;; Generate the bipartite graph
  (define-values (pa pb edges) (rnd-bipartite-graph n m k t))

  ;; Write graph parameters
  (fprintf out "~a ~a ~a\n" n m (length edges))

  ;; Write edges
  (for-each (λ (edge) (fprintf out "~a ~a\n" (first edge) (second edge))) edges)

  (close-output-port out))

;; Function to generate random test cases and write them to a file
(define (generate-random-test-case-to-file test-count min-a max-a filename print-t-n?)
  "Generate test cases with random values and save to a file."
  (define out (open-output-file filename #:mode 'text #:exists 'replace))

  ;; Print number of test cases only if requested
  (when print-t-n?
    (displayln "T: " out)) ;; You can adjust this output for the number of test cases

  ;; Generate and write each test case to the file
  (for ([i (in-range test-count)])
    ;; Generate two random integers
    (define arr (list (rnd-rand-int min-a max-a) (rnd-rand-int min-a max-a)))
    ;; Write test case header (if needed)
    (when print-t-n?
      (displayln (format "N: ~a" (length arr)) out)) ;; Print the value of N if needed
    ;; Write the integers
    (for-each (λ (elem) (fprintf out "~a " elem)) arr)  ;; Print the integers without brackets
    (newline out))  ;; Newline after each test case

  (close-output-port out))

;; Function to generate custom test cases and write them to a file
(define (generate-custom-test-case-to-file test-count sum-n min-a max-a filename)
  "Generate custom test cases based on user input and save to a file."
  (define lengths (rnd-partition test-count sum-n))

  (define out (open-output-file filename #:mode 'text #:exists 'replace))

  ;; Write number of test cases
  (displayln test-count out)

  ;; Generate and write each test case to the file
  (for-each
   (λ (n)
     (define arr (build-list n (λ (_) (rnd-rand-int min-a max-a))))
     (displayln n out)
     (for-each (λ (elem) (fprintf out "~a " elem)) arr)  ;; Print elements without brackets
     (newline out))  ;; Newline after each test case
   lengths)

  (close-output-port out))
