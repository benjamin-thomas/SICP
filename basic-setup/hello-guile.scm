#|

Guile Scheme can run as a shebang script

REPL:
  guile -l ./hello-guile.scm

RUN
  guile ./hello-guile.scm

|#

(define
  (add a b)
  (+ a b))

(define
  (mul a b)
  (* a b))

(begin
  (display "Hello, Guile!")
  (newline))
