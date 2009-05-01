open Eig
open Bigarray.Array2
open ClearLosers
open ReadWinMatrix

let colSums n x =
  let ans = Array.make n 0.0 in
    for i = 0 to n-1 do
      for j = 0 to n-1 do
	ans.(j) <- ans.(j) +. x.(i).(j)
      done
    done;
    ans
      
let transRightInv a =
  let n = Array.length a in
  let c = colSums n a in
    for i = 0 to n-1 do
      for j = 0 to n-1 do
        a.(i).(j) <- a.(i).(j) /. c.(i)
      done
    done
    
let district1qual2009 = Array.map (Array.map float)
  [|[|0;1;0;0;0;0;0;0;0;0;0|]; (*Chico only beat Fullerton RS*)
    [|0;0;0;0;0;0;0;0;1;1;0|]; (*Fullerton RS only beat SF GS and UCLA*)
    [|0;0;0;1;0;0;1;0;1;0;1|];
    [|0;1;0;0;0;0;0;0;1;1;0|];
    [|1;1;1;0;0;0;0;0;0;0;0|]; (*SLO only beat Chico and the Fullertons *)
    [|0;0;0;0;0;0;1;1;1;1;0|]; (*Redlands beat both SFs, Sac, and UCLA*)
    [|1;1;0;0;0;0;0;0;1;0;0|];
    [|0;0;1;1;1;0;0;0;0;1;0|];
    [|0;0;0;0;0;0;0;0;0;1;0|]; (* SFSU GS only beat UCLA *)
    [|1;0;0;0;0;0;0;0;0;0;0|]; (* UCLA only beat Chico *)
    [|1;0;0;0;1;1;0;1;0;0;0|]|]

let arrange n x =
  let low  = ref x.{1} in
  let high = ref x.{1} in
    for i = 2 to n do
      low  := min !low  x.{i};
      high := max !high x.{i}
    done;
    min (abs_float !low) (abs_float !high)
    
let nozeros n x =
  let ans = ref true in 
    for i = 1 to n do
      if x.{i} = 0.0
      then ans := false
    done;
    !ans

let mostOneSignedColumn n imag cols =
  let best = ref None in
    for i = 1 to n do
      let col = slice_right cols i in
	if (imag.{i} = 0.0) (* && nozeros n col *)
	then begin
	  let a = arrange n col in
	    match !best with
	      | None -> 
		  best := Some (i,a)
	      | Some (j,b) ->
		  if a < b
		  then best := Some (i,a)
	end
    done;
    match !best with
      | Some (j,_) -> slice_right cols j

let rec allWinsAllLossesAccum x ts (w,l) =
  match ts with
    | [] -> (w,l)
    | t :: r ->
	let v = Array.fold_left (+.) 0.0 x.(t-1) in
	  if v = 0.0
	  then allWinsAllLossesAccum x r (w,t::l)
	  else allWinsAllLossesAccum x r (t::w,l)
	    
let allWinsAllLosses x ts = allWinsAllLossesAccum x ts ([],[])

let absBigArray n x =
  let ans = Array.make n 0.0 in
    for i = 1 to n do
      ans.(i-1) <- abs_float x.{i}
    done;
    ans

let zip _ a b = Array.mapi (fun i v -> (v,b.(i))) a

let fromBigSq x =
  let n = dim1 x in
  let ans = Array.make_matrix n n 0.0 in
    for i=0 to n-1 do
      for j=0 to n-1 do
	ans.(j).(i) <- x.{j+1,i+1}
      done
    done;
    ans

let print_ff_array x =
  let n = Array.length x in
    for i = 0 to n-1 do
      for j = 0 to n-1 do
	print_float x.(i).(j);
	print_newline ()
      done;
      print_newline ()
    done

let print_f_big n x =
  for i = 1 to n do
    print_float x.{i};
    print_newline ()
  done


let fairBets x =

  let (nom,mat,notin) = clearLosers x in
(*
  let n = Array.length x in
  let nom = 
    let ans = Array.make n 0 in
      for i = 1 to n do
	ans.(i-1) <- i
      done;
      ans in
  let notin = [] in
  let mat = x in
*)
  let n = Array.length nom in
  let (w,l) = allWinsAllLosses x notin in
  let imag,eigv = rightEigenColumns mat in
(*
    print_ff_array (fromBigSq eigv);
    print_f_big n imag;
*)
  let bets = absBigArray n (mostOneSignedColumn n imag eigv) in
  let named = zip n bets nom in
  let invcmp i j = -(compare i j) in
    Array.sort invcmp named;
    w,named,l

let district1qual2009bad = Array.map (Array.map float)
  [|[|0;1;0;0;1;1;1;1;0;0;0;1|]; (*Cal beat everyone they debated*)
    [|0;0;1;0;0;0;0;0;0;0;0;0|]; (*Chico only beat Fullerton RS*)
    [|0;0;0;0;0;0;0;0;0;1;1;0|]; (*Fullerton RS only beat SF GS and UCLA*)
    [|0;0;0;0;1;0;0;1;0;1;0;1|];
    [|0;0;1;0;0;0;0;0;0;1;1;0|];
    [|0;1;1;1;0;0;0;0;0;0;0;0|]; (*SLO only beat Chico and the Fullertons *)
    [|0;0;0;0;0;0;0;1;1;1;1;0|]; (*Redlands beat both SFs, Sac, and UCLA*)
    [|0;1;1;0;0;0;0;0;0;1;0;0|];
    [|0;0;0;1;1;1;0;0;0;0;1;0|];
    [|0;0;0;0;0;0;0;0;0;0;1;0|]; (* SFSU GS only beat UCLA *)
    [|0;1;0;0;0;0;0;0;0;0;0;0|]; (* UCLA only beat Chico *)
    [|0;1;0;0;0;1;1;0;1;0;0;0|]|]

let rec print_int_list x = 
  match x with
    | [] -> ()
    | y :: ys ->
	print_int y;
	print_newline ();
	print_int_list ys

let rec print_fi_array x =
  let n = Array.length x in
    for i = 0 to n-1 do
      let (a,b) = x.(i) in
	print_float a;
	print_newline ();
	print_int b;
	print_newline ()
    done

let no v = 
  let (a,b,c) = fairBets v in
    print_int_list a;
    print_endline "---";
    print_fi_array b;
    print_endline "---";
    print_int_list c

let () = 
  let v = fillWins () in
    no v

(*
let () = 
  let (imagParts,cols) = rightEigenColumns district1qual2009 in
    for i = 1 to 11 do
      print_float imagParts.{i};
      print_newline();
      for j = 1 to 11 do
	print_float cols.{i,j};
	print_newline ()
      done;
      print_newline ()
    done
*)
