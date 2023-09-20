#|
Source:
  https://medium.com/@joshfeltonm/setting-up-emacs-for-sicp-from-scratch-daa6473885c5

Installation:
  apt install mit-scheme

Emacs:
  C-c M-e evaluates the current function
  See: https://gitlab.com/emacs-geiser/geiser
  M-x geiser: starts a REPL

Load via the REPL:
  rlwrap mit-scheme --load ./hello-mit.scm
|#

(define (fib n)
  (if (< n 2) 1
      (+
       (fib (- n 1))
       (fib (- n 2)))))

(+ 3 5)
(* 5 5)

(apropos 'vector)
(pp +)
