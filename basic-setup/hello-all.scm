#|

MIT
mit-scheme --quiet < ./basic-setup/hello-all.scm

CHICKEN
csi -s ./basic-setup/hello-all.scm

GUILE
guile -s ./basic-setup/hello-all.scm

|#

(display "Hello, World!")
(newline)
