#lang sicp

(#%require rackunit rackunit/text-ui)


#|
In Dr Racket, press Ctrl-R to run the tests. Ctrl-D twice to refocus the editor.

To run the tests via the command line, use:
  echo ./chapter-01b.scm | entr -c raco test /_

Although, running the script via the `racket` binary would work, I get a better output (and a non-zero exit code on failure!) with `raco test`.


drracket-paredit keybings

## Implemented:

Movement:
* `("c:m:f")` paredit-forward-sexp
* `("c:m:b")` paredit-backward-sexp
* `("c:m:d")` down-sexp ;rebind to `"c:m:d"`
* `("m:right")` forward-atom ;this is not paredit shortcuts, but alternative for forward-word
* `("m:left")` backward-atom ;ditto


Depth-Changing:
* `("m:s")` paredit-splice-sexp
* `("m:(")` paredit-wrap-round
* `("m:up")` paredit-splice-sexp-killing-backward
* `("m:down")` paredit-splice-sexp-killing-forward
* `("m:r")` paredit-raise-sexp
* `("m:?")` paredit-convolute-sexp

Slurpage & barfage
* `("c:right")` paredit-slurp-forward
* `("c:m:left")` paredit-slurp-backward
* `("c:left" "c:}")` paredit-barf-forward
* `("c:m:right" "c:{")` paredit-barf-backward

|#

; Exercise 1.1: Below is a sequence of expressions. What is the result
; printed by the interpreter in response to each expression? Assume
; that the sequence is to be evaluated in order in which it is presented.

(check-equal? 9 (+ 5 3 1))

(check-equal? 8 (- 9 1))
(check-equal?  3 (/ 6 2))
(check-equal? 6 (+ (* 2 4) (- 4 6)))

(define a 3)
(define b (+ a 1))

(check-equal? 19 (+ a b (* a b)))

(check-equal? #f (= a b))

(check-equal? 4 (if (and (> b a) (< b (* a b)))
                    b
                    a))

(check-equal? 16 (cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25)))

(check-equal? 6 (+ 2 (if (> b a) b a)))

(check-equal? 16 (* (cond ((> a b) a)
	 ((< a b) b)
	 (else -1))
   (+ a 1)))



;; Exercise 1.2: Translate the following expression into prefix form:
(check-equal? (/ -13 60) (/ (+ 5 4 (- 2 (- 3 (+ 6 (- 4 5)))))
   (* 3 (- 6 2) (- 2 7))))



;; Exercise 1.3: Define a procedure that takes three numbers
;; as arguments and returns the sum of the squares of the two
;; larger numbers.
(define (sum-of-squares a b)
  (+ (* a a) (* b b)))

(define (square-of-top a b c)
  (cond ((= a (min a b c)) (sum-of-squares b c))
	((= b (min a b c)) (sum-of-squares a c))
	((= c (min a b c)) (sum-of-squares a b))))

(check-equal? 52 (square-of-top 2 4 6))
(check-equal? 52 (square-of-top 4 2 6)) 
(check-equal? 52 (square-of-top 6 4 2))


;; Mathy solution: got this one from the net
(define (square-two-largest a b c) 
 (- (+ (* a a) (* b b) (* c c))
    (* (min a b c) (min a b c)))) 

(check-equal? 52 (square-two-largest 2 4 6))
(check-equal? 52 (square-two-largest 4 2 6))
(check-equal? 52 (square-two-largest 6 4 2))

