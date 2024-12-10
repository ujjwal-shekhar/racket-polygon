# Problem PDF Generator, Validator, and Test Case Generator in Racket

This project provides a flexible framework to generate problem PDFs, validate test cases, and create random test cases for competitive programming problems. It uses **Racket** and includes a **Domain-Specific Language (DSL)** for defining test case generators and validators.

## Table of Contents

- [Problem PDF Generator](#problem-pdf-generator)
- [Validator](#validator)
- [Test Case Generator DSL](#test-case-generator-dsl)
- [How to Use the Framework](#how-to-use-the-framework)
- [Directory Structure](#directory-structure)

## Problem PDF Generator

The **Problem PDF Generator** creates a problem folder and generates a PDF of the problem description using LaTeX. It includes an easy way to specify the problem, time limits, memory limits, sample tests, and notes.

### How to Use

1. **Define the Problem**: Create a problem by using the `define-problem` macro with problem details like the problem name, time and memory limits, description, input/output formats, sample tests, and notes.
  
   Example:
   ```racket
   (define my-problem
     (define-problem "Sum of Two Numbers"
       #:time-limit 1
       #:memory-limit 128
       #:description "Compute the sum of two integers \\(a\\) and \\(b\\)."
       #:input-format "The input consists of two integers \\(a\\) and \\(b\\)."
       #:output-format "Output a single integer representing the sum \\(a + b\\)."
       #:sample-tests '(("1 2" "3") ("5 10" "15"))
       #:notes "Ensure the inputs satisfy \\(1 \\leq a, b \\leq 10^9\\)."))
   ```

2. **Create the Problem Folder and Generate the PDF**: Use the `create-problem-folder` function to create a folder and generate a LaTeX file and PDF.
   
   Example:
   ```racket
   (module+ main
     (create-problem-folder my-problem "./problems"))
   ```

## Validator

The **Validator** checks whether the generated test cases match the expected output for a given problem. It uses a user-defined validator to perform the validation.

### How to Use

1. **Define the Validator**: Create a validator function in `user-code/user-validator.rkt`. The validator checks if the output for a given test case is correct.

2. **Run the Validator**: Use the `run-validation` function to execute the validation process.

   Example:
   ```racket
   #lang racket

   (require "src/core/validator-dsl.rkt"        ; Path to core DSL
            "user-code/user-validator.rkt")    ; Path to user-defined validator

   (provide run-validation)

   ; Validate problem test cases
   (define (run-validation validator tests-path)
     (define (absolute-paths dir)
       (map (lambda (p) (build-path dir p))
            (directory-list dir)))

     (define (load-tests path)
       (map file->string (absolute-paths path))) ; Load all test files as strings

     (define tests (load-tests tests-path))
     (validate-tests validator tests))

   (module+ main
     (printf "Running validator...\n")
     (run-validation validate-sum-of-two-numbers "user-code/tests"))
   ```

## Test Case Generator DSL

The **Test Case Generator DSL** allows users to generate test cases for competitive programming problems. It supports generating **multiple test cases** or **single test case** problems and provides flexibility in controlling output formatting, such as whether or not to print `T` (number of test cases) or `N` (test case size).

### How to Use

1. **Define the Test Case Generation Logic**: Use the provided functions in `src/core/test-case-generator-dsl.rkt` to generate random test cases or custom test cases. You can specify parameters like the number of test cases, range of values, and file output.

2. **Create Your Test Case Generator**: Example code for generating test cases for two integers:

   ```racket
   #lang racket

   (require "../src/core/test-case-generator-dsl.rkt")

   ;; Set parameters for test case generation
   (define test-count 1)
   (define min-a 1)
   (define max-a 100000)
   (define filename "user-code/tests/generated-test-cases.txt")

   ;; Generate test cases and write to the file
   (generate-random-test-case-to-file test-count min-a max-a filename)
   ```

3. **Put the Generator and Validator in the User Code**: The user will place their **generator** and **validator** code in `user-code/user-generator.rkt` and `user-code/user-validator.rkt`, respectively.

4. **Running the Test Case Generator**: After defining the generator and validator, run the pipeline by invoking the relevant functions from your user scripts.

## How the Pipeline Works

1. **Problem Definition**: The user defines the problem using the `define-problem` macro, which includes the problem name, time and memory limits, sample inputs/outputs, and any notes.
2. **PDF Generation**: The problem is then passed to the `create-problem-folder` function, which generates the LaTeX file, compiles it, and produces a PDF.
3. **Test Case Generation**: The user defines the test case generation logic (using random or custom generation) and stores it in `user-code/user-generator.rkt`. This file is used by the pipeline to generate test cases.
4. **Validation**: The user defines the validation logic for the test cases and stores it in `user-code/user-validator.rkt`. This is used to validate that the output for each test case is correct.
5. **Execution**: The user can run the test case generation and validation process by executing the relevant functions in their user code.

## Directory Structure

The following is the directory structure of the project:

```
/project-root
├── src
│   ├── core
│   │   ├── problem.rkt
│   │   ├── latex-generator.rkt
│   │   ├── pdf-generator.rkt
│   │   ├── test-case-generator-dsl.rkt
│   │   └── validator-dsl.rkt
├── user-code
│   ├── user-generator.rkt
│   ├── user-validator.rkt
│   └── tests
│       └── generated-test-cases.txt
└── problems
    └── Sum_of_Two_Numbers
        └── problem.pdf
```

## Installation

1. Clone the repository.
2. Install **Racket** on your machine if you haven't already: [https://racket-lang.org/](https://racket-lang.org/).
3. Navigate to the project directory and start writing your generator and validator code in the `user-code` directory.
