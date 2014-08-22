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
 *    Text encoding:      UTF-8
 *
 *    Created 2014-08-20: Ulrich Singer
 *)


(**
 *  A table type that maps prime factors to their occurence count.
 *)
module FacMem =
struct
  type keyT = int
  type valT = int

  module IntMap = Map.Make (struct type t = keyT let compare = compare end)
  type t = valT IntMap.t

  let empty: t = IntMap.empty

  let increase mem fac =
    let old = try IntMap.find fac mem with Not_found -> 0
    in IntMap.add fac (old + 1) mem

  let factors mem = IntMap.bindings mem
end


(**
 *  Prime factor decomposition.
 *  Returns a list of (P, E) pairs, where P is a prime factor and E
 *  is its occurence count (exponent).  For prime numbers, the list
 *  has only one element with E = 1.  0 and 1 yield an empty list.
 *)
let pfd (num: int): (int * int) list =
  let rec facloop arg fac top mem =
    if arg = 1 then mem
    else if fac > top || fac > arg then FacMem.increase mem arg
    else if arg mod fac = 0 then facloop (arg / fac) fac top (FacMem.increase mem fac)
    else facloop arg (fac + if fac = 2 then 1 else 2) top mem
  and isqrt num = num |> float_of_int |> sqrt |> ceil |> int_of_float
  and pfd' arg mem =
    if arg < 0 then pfd' (- arg) mem
    else if arg < 2 then mem
    else if arg < 4 then FacMem.increase mem arg
    else facloop arg 2 (isqrt arg) mem
  in
  pfd' num FacMem.empty |> FacMem.factors
;;


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
let deriv (num: int): int =
  let rec derloop u u' vs =
    match vs with
    | []      -> u'
    | v :: ws ->
      let vv = pair_value v
      in derloop (u * vv) (u' * vv + u * pair_deriv v) ws
  and ipow base expn =
    let rec powloop xpn acc =
      if xpn > 0 then powloop (xpn - 1) (base * acc) else acc
    in powloop expn 1
  and pair_deriv (fac, xpn) = xpn * ipow fac (xpn - 1)
  and pair_value (fac, xpn) = ipow fac xpn
  in
  match (pfd num) with
  | []          -> 0
  | car :: cdr  -> derloop (pair_value car) (pair_deriv car) cdr
;;


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
    Printf.printf "%d\n" (deriv num)
  done
;;


(* ~ numder.ml ~ *)
