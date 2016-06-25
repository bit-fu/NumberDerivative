(*  ========================================================================  *
 *
 *    numder.ml
 *    ~~~~~~~~~
 *
 *    Derivatives of numbers
 *
 *    Refer to:           1961 paper of Edward Barbeau:
 *                        http://cms.math.ca/cmb/v4/cmb1961v04.0117-0122.pdf
 *
 *                        The on-line encyclopedia of integer sequences:
 *                        http://oeis.org/A003415
 *
 *                        This article at “Gödel’s Lost Letter and P=NP”:
 *                        http://rjlipton.wordpress.com/2014/08/19/the-derivative-of-a-number/
 *
 *    Target language:    OCaml-4.02
 *
 *    Text encoding:      UTF-8
 *
 *    Created 2014-08-20: Ulrich Singer
 *)


let bitwidth num =
  let rec count bits = function
    | 0 -> bits
    | n -> count (bits + 1) (n lsr 1)
  in
  count 0 num


let isqrt num =
  let rec track rt =
    if rt * rt < num then track (rt + 1) else rt
  in
  let lb = (bitwidth num + 1) / 2 in
  track (num lsr lb)


let ipow num xpn =
  let rec emul acc fac rst =
    if rst < 1 then acc
    else
      emul (if rst land 1 <> 0 then acc * fac else acc) (fac * fac) (rst lsr 1)
  in
  emul 1 num xpn


(**
 *  Prime factor decomposition.
 *  Returns a list of (P, E) pairs, where P is a prime factor and E
 *  is its occurence count (exponent).  For prime numbers, the list
 *  has only one element with E = 1.  0 and 1 yield an empty list.
 *)

let primefactors num =
  let root = isqrt num in
  let countup num = function
    | (cmp,cnt)::cdr when cmp = num -> (num, cnt+1)::cdr
    | lst -> (num, 1)::lst
  in
  let rec find accu prod fact =
    if prod = 1
    then List.rev accu
    else if fact > min root prod
    then List.rev (countup prod accu)
    else if prod mod fact = 0
    then find (countup fact accu) (prod / fact) fact
    else find accu prod (fact + if fact = 2 then 1 else 2)
  in
  if num < 2 then []
  else find [] num 2


(**
 *  D(0) = D(1) = 0
 *  D(p)        = 1  for prime p
 *  D(u v)      = u D(v) + v D(u)
 *                u > 0  ∧  v > 0
 *
 *  ———————————————————————————————————
 *
 *  (u v)'  =  u' v + v' u
 *  |
 *      u   =  a b
 *  =>
 *      u'  =  a' b + b' a
 *  =>
 *  (u v)   =  (a b) v
 *  =>
 *  (u v)'  =  (a' b + b' a) v + v' (a b)
 *)
let deriv num =
  let pair_value (fac, xpn) = ipow fac xpn in
  let pair_deriv (fac, xpn) = xpn * ipow fac (xpn - 1) in
  let rec derloop u u' = function
    | v::vs ->
      let vv = pair_value v
      in derloop (u * vv) (u' * vv + u * pair_deriv v) vs
    | [] -> u'
  in
  match (primefactors num) with
  | car::cdr -> derloop (pair_value car) (pair_deriv car) cdr
  | []       -> 0


(**
 *  Main body.
 *
 *  Interprets each program argument as an integer and prints its derivative.
 *)
let () =
  for ind = 1 to Array.length Sys.argv - 1
  do
    let arg = Sys.argv.(ind) in
    let num = try int_of_string arg with Failure _ -> 0 in
    Printf.printf "%d' = %d\n" num (deriv num)
  done
;;


(* ~ numder.ml ~ *)
