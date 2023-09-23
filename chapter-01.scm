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

;; Exercise 1.4: Observe that our model of evaluation allows
;; for combinations whose operators are compound expressions. Use this observation to describe the behavior of the
;; following procedure:

(set! a 1)
(set! b 2)
(define (a-plus-abs-b a b)
	((if (> b 0) + -) a b))

; When true, the if expression get reduces as:
;((if #t + -) 2 3); result=5, same as:
;(+ 2 3); result=5

; When false, the if expression get reduces as:
;((if #f + -) 2 3); result=-1, same as:
;(- 2 3); result=-1


#|
Exercise 1.5:

Ben Bitdiddle has invented a test to determine whether the interpreter he is faced with is using
applicativeorder evaluation or normal-order evaluation. He defines the following two procedures:

(define (p) (p))

(define (test x y)
  (if (= x 0) 0 y))

en he evaluates the expression:

(test 0 (p))

What behavior will Ben observe with an interpreter that uses applicative-order evaluation?
What behavior will he observe with an interpreter that uses normal-order evaluation?

Explain your answer.

In normal-order evaluation, the inner parens will be evaluated first.

(test 0 (p)); evaluates to
(test 0 (p)); evaluates to
(test 0 (p)); evaluates to
(test 0 (p)); etc.

Because (p) is evaluated first, but since (p) is returned we enter an infinite loop.


In applicative-order evalution, the evaluation would have been:
(test 0 (p)); evaluates to
(if (= 0 0) 0 (p)); evaluates to
(if #t 0 (p)); evaluates to
0

|#



; Implementing square roots with Newton's method
(define (square x)
  (* x x))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

;Exercise 1.6
(define (new-if predicate
                then-clause
                else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
  ;(new-if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))

(define (average x y)
  (/ (+ x y) 2))

(define (improve guess x)
  (average guess (/ x guess)))

(define (sqrt x)
  (sqrt-iter 1.0 x))

#|
Exercise 1.6
============

Define `new-if` and observe that it won't be usable with recursion.

Answer:
=======

We enter an infinite loop because of Lisp's applicative-order evaluation.
Both branches of `new-if` get evaluated, thus we recursively evaluate the false branch (even when the a branch is true).

(add (* 2 2) (* 3 3)) ; evaluates to:
(add 4 9) ; evaluates to:
13

We can also easily see this by tracing the function `new-if`
============================================================

(trace new-if)

1 ]=> (new-if #f 1 (+ 1 1))

[Entering #[compound-procedure 13 new-if]
    Args: #f
          1
          2]
[2
      <== #[compound-procedure 13 new-if]
    Args: #f
          1
          2]
;Value: 2

1 ]=> (new-if #t 1 (+ 1 1))

[Entering #[compound-procedure 13 new-if]
    Args: #t
          1
          2]
[1
      <== #[compound-procedure 13 new-if]
    Args: #t
          1
          2]
;Value: 1

Here, we can easily see that (+ 1 1) is always evaluated.

`if` is a special form that evaluates the predicate first, then evaluates branch a OR branch b.


============
*** NOTE ***
============

To debug the program, here's how to proceed:

Step 1: set a break
-------------------

(define (sqrt-iter guess x)
 (bkpt guess x); <-- break point here, the arguments will be printed when hitting the breakpoint
 (new-if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))



Step 2: load the program
-------------------------
Something like `rlwrap mit-scheme --load ./debug.scm`

Step 3: advance in the program
------------------------------
(continue)

I could not find any other debugging commands unfortunatly.
|#
(sqrt 25)
