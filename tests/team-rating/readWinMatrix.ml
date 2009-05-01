(* open ClearLosers *)

let emptyWins () = 
  let _ = read_line () in
  let size = read_int () in
    Array.make_matrix size size 0.0

let rec fillWinsEach n wins =
  match n with
    | 0 -> wins
    | _ -> 
	let i = read_int () in
	let j = read_int () in
	let num = float (read_int ()) in
	  wins.(i-1).(j-1) <- num;
	  fillWinsEach (n-1) wins

let fillWins () =
  let wins = emptyWins () in
  let _ = read_line () in
  let records = read_int () in
  let _ = read_line () in
    fillWinsEach records wins
(*
let wins () = 
  let v = fillWins () in
  let (nom,mat,out) = clearLosers v in
  print_int (Array.length nom)
*)
