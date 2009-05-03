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

let rec teamNames n nom =
  match n with
    | 0 -> nom
    | _ -> 
	let i = read_int () in
	let j = read_line () in
	  nom.(i-1) <- j;
	  teamNames (n-1) nom


let fillWins () =
  let wins = emptyWins () in
  let _ = read_line () in
  let numnames = read_int () in
  let _ = read_line () in
  let nom = teamNames numnames (Array.make (Array.length wins) "") in
  let _ = read_line () in
  let records = read_int () in
    if records > 0
    then 
      let _ = read_line () in
      let mat = fillWinsEach records wins in
	nom,mat
    else
      nom,wins
(*
let wins () = 
  let v = fillWins () in
  let (nom,mat,out) = clearLosers v in
  print_int (Array.length nom)
*)
