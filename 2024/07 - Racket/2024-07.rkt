#lang racket

(define (apply-op op a b)
  (case op
    ['+ (+ a b)]
    ['* (* a b)]
    ['|| (string->number ; Convert nums to string, concat, convert back
          (string-append 
            (number->string a)
            (number->string b)))]))

; Recursively generate all possible operator combinations for n numbers
(define (generate-operator-combinations n operators)
  (if (= n 1)
      '(())  ; base case: no operators needed for 1 number
      (for*/list ([ops (generate-operator-combinations (- n 1) operators)]
                  [new-op operators])
        (append ops (list new-op)))))

(define (try-combination ns ops)
  (let loop ([result (first ns)] ; Start with first number
             [rest-nums (rest ns)] ; Rest of the numbers
             [rest-ops ops]) ; All operators
    (if (null? rest-nums)
        result ; If there are no more numbers, return the result
        (loop (apply-op (first rest-ops) ; Apply operator to result and next number
                       result             
                       (first rest-nums))
              (rest rest-nums) ; Continue with remaining numbers
              (rest rest-ops))))) ; Continue with remaining operators

; Sum the answers to the valid calibration equations
(define (sum-calibration-equations input operators)
  (for/sum ([calibration-equation input])
    (for/fold ([result 0])
              ([combo (generate-operator-combinations
                     (- (length calibration-equation) 1)
                     operators)])
    #:break (not (zero? result))  ; break when we find a non-zero result
    (if (= (first calibration-equation)
           (try-combination (rest calibration-equation) combo))
        ; ^ first and rest used to get answer and equation
        (first calibration-equation)  ; return the answer when found
        result))))

; Load the input file
(define filename "input.txt")
(define file (open-input-file filename))
(define input-str (read-string (file-size filename) file))
(close-input-port file)

; Parse the input file
(define (parse-input input-str)
  (let ([parse-line (lambda (line)
          (map string->number (string-split (string-replace line ":" ""))))])
    (map parse-line
         (string-split input-str "\n"))))


(define equations (parse-input input-str))

(sum-calibration-equations equations '(+ *))
(sum-calibration-equations equations '(+ * ||))
