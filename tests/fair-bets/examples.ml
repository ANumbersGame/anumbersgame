let flArray x = 
  Array.map (Array.map (fun y -> float y)) x

(* An example from Russell Hanes *)
let mat' = flArray
  [|[|0;1;0;1;1;1|]; 
    [|0;0;1;0;1;1|]; 
    [|1;0;0;0;1;1|]; 
    [|0;1;1;0;0;1|];
    [|0;0;0;1;0;1|];
    [|0;0;0;0;0;0|]|]

(*In order but for one big surprise *)
let oneBigUpset = flArray
  [|[|0;1;1;1;1;1;1;0|]; 
    [|0;0;1;1;1;1;1;1;|]; 
    [|0;0;0;1;1;1;1;1|]; 
    [|0;0;0;0;1;1;1;1|];
    [|0;0;0;0;0;1;1;1|];
    [|0;0;0;0;0;0;1;1|];
    [|0;0;0;0;0;0;0;1|];
    [|1;0;0;0;0;0;0;0|]|]

(* Same as oneBigUpset, but smaller tournament *)
let oneLittleUpset = flArray
  [|[|0;1;1;1;0|]; 
    [|0;0;1;1;1|]; 
    [|0;0;0;1;1|]; 
    [|0;0;0;0;1|];
    [|1;0;0;0;0|]|]

(* Example from Michael Stob's "Rankings from round-robin tournaments" *)
let stob = flArray
  [|[| 0; 0; 1; 1; 1; 1; 1|];   
    [| 1; 0; 1; 1; 0; 0; 0|];   
    [| 0; 0; 0; 1; 1; 1; 0|];   
    [| 0; 0; 0; 0; 1; 1; 1|];   
    [| 0; 1; 0; 0; 0; 1; 1|];   
    [| 0; 1; 0; 0; 0; 0; 1|];   
    [| 0; 1; 1; 0; 0; 0; 0|]|]

let rPexample1 = 
  [|[|0.0; 1.0; 0.9; 0.9|];
    [|1.0; 0.0; 0.9; 0.0|];
    [|0.1; 0.1; 0.0; 0.0|];
    [|0.1; 0.0; 0.0; 0.0|]|]
let rPexample2 = 
  [|[|0.0; 1.0; 90.0; 0.9|];
    [|1.0; 0.0; 0.9; 0.0|];
    [|10.0; 0.1; 0.0; 0.0|];
    [|0.1; 0.0; 0.0; 0.0|]|]
let rPexample3 = 
  [|[|0.0; 0.9; 90.0; 0.9|];
    [|1.1; 0.0; 0.9; 0.0|];
    [|10.0; 0.1; 0.0; 0.0|];
    [|0.1; 0.0; 0.0; 0.0|]|]
let rPexample4 = 
  [|[|0.0; 100.0; 0.9; 0.9|];
    [|100.0; 0.0; 0.9; 0.0|];
    [|0.1; 0.1; 0.0; 0.0|];
    [|0.1; 0.0; 0.0; 0.0|]|]
let rPexample5 = 
  [|[|0.0; 2.0; 1.8; 1.8|];
    [|2.0; 0.0; 0.9; 0.0|];
    [|0.2; 0.1; 0.0; 0.0|];
    [|0.2; 0.0; 0.0; 0.0|]|]
let rPfootnote11a = 
  [|[|0.0; 0.55; 9.0; 9.0|];
    [|0.45; 0.0; 5.0; 5.0|];
    [|1.0; 5.0; 0.0; 9.0|];
    [|1.0; 5.0; 1.0; 0.0|]|]
let rPfootnote11b = 
  [|[|0.0; 55.0; 9.0; 9.0|];
    [|45.0; 0.0; 5.0; 5.0|];
    [|1.0; 5.0; 0.0; 9.0|];
    [|1.0; 5.0; 1.0; 0.0|]|]

let d1qual2009 = flArray
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

let d1names = [|"Cal";"Chico";"Fullerton RS";"Fullerton BG";
		"Pepperdine";"SLO";"Redlands";"Sac";"SF EW";
		"SF GS";"UCLA";"USC"|]

(* RP can't do this, but MLE can *)
let mlecan = [|[|0.0;1.0|];
	       [|1.0;0.0|]|]

(* MLE can't do this in one component, but I think RP can *)
let rpcan = flArray
  [|[|0;1;1;1;1|];
    [|1;0;1;1;1|];
    [|0;0;0;1;1|];
    [|0;0;0;0;1|];
    [|0;0;0;1;0|]|]
(*
let mlhaff = flArray
  [|[|0;1;1;1;1|];
    [|0;0;1;1;1|];
    [|0;0;0;1;1|];
    [|0;0;0;0;1|];
    [|1;0;0;0;0|]|]

let mlhneg = flArray
  [|[|0;1;0;0;0|];
    [|1;0;1;0;0|];
    [|0;1;0;1;0|];
    [|0;0;1;0;1|];
    [|0;0;0;1;0|]|]
*)

(*
let mlhaff = flArray
  [|[|0;1;1;1|];
    [|0;0;1;1|];
    [|0;0;0;1|];
    [|1;0;0;0|]|]

let mlhneg = flArray
  [|[|0;1;0;0|];
    [|1;0;1;0|];
    [|0;1;0;1|];
    [|0;0;1;0|]|]
*)
(*
let mlhaff = flArray
  [|[|0;1;1;1;1;1|];
    [|0;0;1;1;1;1|];
    [|0;0;0;1;1;1|];
    [|0;0;0;0;1;1|];
    [|0;0;0;0;0;1|];
    [|1;0;0;0;0;0|]|]

let mlhneg = flArray
  [|[|0;1;0;0;0;0|];
    [|1;0;1;0;0;0|];
    [|0;1;0;1;0;0|];
    [|0;0;1;0;1;0|];
    [|0;0;0;1;0;1|];
    [|0;0;0;0;1;0|]|]
*)

let mlhaffwin = flArray
  [|[|0;82;10;10|];
    [|82;0;10;10|];
    [|10;10;0;82|];
    [|10;10;82;0|]|]

let mlhafflos = flArray
  [|[|0;1;1;1|];
    [|1;0;1;1|];
    [|100;100;0;1|];
    [|100;100;1;0|]|]

let mlh n =
  let aff = Array.make_matrix n n 0 in
  let neg = Array.make_matrix n n 0 in
    for i = 0 to n-2 do
      for j = i+1 to n-1 do
	aff.(i).(j) <- 1
      done
    done;
    aff.(n-1).(0) <- 1;
    for i = 1 to n-2 do
      neg.(i).(i-1) <- 1;
      neg.(i).(i+1) <- 1
    done;
    neg.(0).(1) <- 1;
    neg.(n-1).(n-2) <- 1;
    flArray aff, flArray neg
      
let mlhBarely n =
  let aff = Array.make_matrix (2*n) (2*n) 0 in
  let neg = Array.make_matrix (2*n) (2*n) 0 in
    for i = 0 to n-1 do
      aff.(2*i).(2*i+1) <- 9;
      aff.(2*i+1).(2*i) <- 9;
      if i < n-1
      then begin
	aff.(2*i).(2*i+2) <- 9;
	aff.(2*i).(2*i+3) <- 9;
	
	aff.(2*i+1).(2*i+2) <- 9;
	aff.(2*i+1).(2*i+3) <- 9;
      end;
      if i > 0
      then begin
	aff.(2*i).(2*i-1) <- 1;
	aff.(2*i).(2*i-2) <- 1;
	
	aff.(2*i+1).(2*i-1) <- 1;
	aff.(2*i+1).(2*i-2) <- 1;
      end;
      for j = 2*i+4 to 2*n-1 do
	aff.(2*i).(j) <- 10;
	aff.(2*i+1).(j) <- 10;
      done
    done;
    for i = 0 to n-1 do
      neg.(2*i).(2*i+1) <- 1;
      neg.(2*i+1).(2*i) <- 1;
      if i < n-1
      then begin
	neg.(2*i+2).(2*i) <- 9;
	neg.(2*i+3).(2*i) <- 9;
	
	neg.(2*i+2).(2*i+1) <- 9;
	neg.(2*i+3).(2*i+1) <- 9;
      end;
      if i > 0
      then begin
	neg.(2*i-1).(2*i) <- 1;
	neg.(2*i-2).(2*i) <- 1;
	
	neg.(2*i-1).(2*i+1) <- 1;
	neg.(2*i-2).(2*i+1) <- 1;
      end;
      for j = 2*i+4 to 2*n-1 do
	neg.(j).(2*i) <- 10;
	neg.(j).(2*i+1) <- 10;
      done
    done;
    let sum x =
      let ans = ref 0 in
	for i = 0 to 2*n-1 do
	  for j = 0 to 2*n-1 do
	    ans := !ans + x.(i).(j)
	  done
	done;
	!ans in
      flArray aff, flArray neg, sum aff, sum neg
