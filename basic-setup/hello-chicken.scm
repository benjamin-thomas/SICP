#|

Run with Chicken Scheme (compiles to C)

  REPL:
    rlwrap csi ./hello-chicken.scm

  COMPILE
    - csi -s ./hello-chicken.scm
    - csc -o hello ./hello-chicken.scm && ./hello

  TDD:
    echo ./hello-chicken.scm | entr -c csi -s /_

---

Install the testing framework: http://wiki.call-cc.org/eggref/5/srfi-78

  chicken-install srfi-78, as root (?)
|#

(import srfi-78)
(check-set-mode! 'report-failed)

(check (+ 1 2) => 3)

(define (add a b)
  (+ a b))

(check (add 1 2) => 3)

(check-report)
