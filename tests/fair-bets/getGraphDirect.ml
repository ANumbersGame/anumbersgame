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
   from rounds, ballots, tournaments,
(select year, tournament, level, count(distinct affteam) as teams
from rounds
group by year, tournament, level   
) as must,
teams as aff, teams as neg
   where 

aff.year = rounds.year
and aff.id = rounds.affteam

and neg.year = rounds.year
and neg.id = rounds.negteam


and aff.firstroundApplicant = 'yes'
and neg.firstroundApplicant = 'yes'


and must.tournament = rounds.tournament
and must.year = rounds.year
and must.level = rounds.level
/*
and must.teams > 60

and (roundNum < 0)
*/
/*
and tournaments.shortname = 'NDT'
*/
   and rounds.year = ballots.year
   and rounds.id = ballots.round
/*
   and rounds.level = 'JV'
*/
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

let mat_transpose a =
  let n = Array.length a in
  let ans = Array.make_matrix n n 0.0 in
    for i = 0 to n-1 do
      for j = 0 to n-1 do
	ans.(i).(j) <- a.(j).(i) 
      done
    done;
    ans


let mat_add x y =

  let n = Array.length x in
  let m = Array.length y in
  let l = ref (Array.make_matrix 0 0 0.0) in
  let r = ref (Array.make_matrix 0 0 0.0) in
  let t = ref (fun i -> i) in
    if n > m
    then begin
      l := Array.map Array.copy x;
      r := y
    end else begin
      l := Array.map Array.copy y;
      r := x;
      t := mat_transpose
    end;
    for i = 0 to Array.length(!l)-1 do
      for j = 0 to Array.length(!l)-1 do
	if i < Array.length(!r) && j < Array.length(!r)
	then !l.(i).(j) <- !l.(i).(j) +. !r.(j).(i)
      done
    done;
    !t !l

let balance year =
  let (w,l,n) = getEvery year in
  let (wm,lm,nl) = adjList_to_mat w, adjList_to_mat l, assocList_to_arr n in
    mat_add wm lm, wm, lm, nl

