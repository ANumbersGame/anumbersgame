open Mysql

let rec getAll' res ans =
  let row = fetch res in
    match row with
      | None -> ans
      | Some y -> getAll' res (y :: ans)

let getAll res = getAll' res []

let acros yr = 
  "select id, concat(if(firstroundApplicant='yes','*',' '),'\t',name)
   from teams
   where year = "^(string_of_int yr)^"
   and name is not null"

let wins side yr =
  "select affteam, negteam, count(*) as many
   from rounds, ballots, tournaments
   where rounds.year = ballots.year
   and rounds.id = ballots.round
   and ballots.decision = '"^side^"'
   and rounds.year = "^string_of_int yr^"
/*
   and roundNum <= 6
   and roundNum > 0
*/

   and tournaments.year = rounds.year
   and tournaments.id = rounds.tournament
/*
   and tournaments.start <= '"^string_of_int (yr-1)^"-12-31'
*/
   group by affteam, negteam
   order by affteam, negteam"

let fromSome x =
  match x with
    | Some y -> y
    | _ -> failwith "fromSome"

let getIntString x = 
  int_of_string (fromSome x.(0)),
  fromSome x.(1)

let get3ints x =
  int_of_string (fromSome x.(0)),
  int_of_string (fromSome x.(1)),
  int_of_string (fromSome x.(2))

let rec show_IntStrList x =
  match x with
    | [] -> ""
    | (y,z) :: ys -> (string_of_int y) ^ ", " ^ z ^ "\n" ^ show_IntStrList ys

let rec show3intList x =
  match x with
    | [] -> ""
    | (p,q,r) :: ys -> 
	(string_of_int p) ^ ", " ^
	  (string_of_int q) ^ ", " ^ 
	  (string_of_int r) ^ "\n" ^ show3intList ys


let getEvery year = 
  let handl = quick_connect ~user:"admin" () in
    select_db handl "DebateResultsAll";
    let affWins = exec handl (wins "aff" year) in
    let affList = List.map get3ints (getAll affWins) in
    let negWins = exec handl (wins "neg" year) in
    let negList = List.map get3ints (getAll negWins) in
    let res = exec handl (acros year) in
    let noms = List.map getIntString (getAll res) in
      affList, negList, noms

let adjList_to_mat : (int * int * int) list -> float array array =
  fun a ->
    let m = List.fold_right (fun (i,j,_) o -> max i (max j o)) a 0 in
    let ans = Array.make_matrix (m+1) (m+1) 0.0 in
    let f (i,j,w) = ans.(i).(j) <- float w in
      List.iter f a;
      ans

let assocList_to_arr a =
  let m = List.fold_right (fun (i,_) o -> max i o) a 0 in
  let ans = Array.make (m+1) "" in
  let f (i,s) = ans.(i) <- s in
    List.iter f a;
    ans

let mat_add x y =
  let ans = Array.map Array.copy x in
  let n = Array.length ans in
    for i = 0 to n-1 do
      for j = 0 to n-1 do
	ans.(i).(j) <- ans.(i).(j) +. y.(j).(i)
      done
    done;
    ans

let balance year =
  let (w,l,n) = getEvery year in
  let (wm,lm,nl) = adjList_to_mat w, adjList_to_mat l, assocList_to_arr n in
    mat_add wm lm, wm, lm, nl

