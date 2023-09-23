(* Implement square roots with Newton's method *)

let new_if predicate then_clause else_clause =
  match predicate with
  | true -> then_clause
  | false -> else_clause
;;

let rec countdown n =
  if n <= 0 then
    print_endline "STOP"
  else (
    ()
    ; print_endline "tick"
    ; countdown (n - 1)
  )
;;

(* new_if works here, but that's just happenstance *)
let ok_no_recurr () = new_if true 1 0

(* We enter an infinite loop here, as in Lisp, due to applicative-order evaluation. *)
let rec nok_countdown n =
  new_if (n <= 0) (print_endline "STOP")
    (()
     ; print_endline "tick"
     ; nok_countdown (n - 1))
;;
