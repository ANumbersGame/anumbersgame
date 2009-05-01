module Square : sig
  type square
  val make : float array array -> square
  val transpose : square -> unit
  val swap_out_row : square -> int -> unit
  val size : square -> int
  val rowsum : square -> int -> float
  val snapshot : square -> int array * float array array * int list
end = struct
  type square = Square of bool ref * int ref * int array * float array array * int list ref

  let make x =
    let n = Array.length x in
    let nom = Array.make n 0 in
      for i = 0 to n-1 do
	nom.(i) <- i+1
      done;
      let mat = Array.map Array.copy x in
	Square (ref true, ref n, nom, mat, ref [])

  let transpose (Square (b,_,_,_,_)) =
    b := not (!b)

  let swap_out_row (Square (_,s,nom,mat,obs)) i =
    mat.(i) <- mat.(!s-1);
    for j=0 to !s-2 do
      mat.(j).(i) <- mat.(j).(!s-1)
    done;
    obs := nom.(i) :: !obs;
    nom.(i) <- nom.(!s-1);
    s := !s-1
      
  let size  (Square (_,s,_,_,_)) = !s

  let rowsum (Square (b,s,_,mat,_)) i =
    let ans = ref 0.0 in
      for j=0 to !s-1 do
	ans := !ans +. if !b then mat.(i).(j) else mat.(j).(i)
      done;
      !ans
      
  let snapshot (Square (b,s,nom,mat,obs)) = 
    let ans_mat = Array.make_matrix !s !s 0.0 in
    let ans_nom = Array.make !s 0 in
      for i=0 to !s-1 do
	ans_nom.(i) <- nom.(i);
	for j=0 to !s-1 do
	  ans_mat.(i).(j) <- if !b then mat.(i).(j) else mat.(j).(i)
	done
      done;
      (ans_nom, ans_mat, !obs)
end

let clearLosersIter i x = 
  if Square.size x <= 1
  then false
  else 
    if i > (Square.size x)-1
    then false
    else 
      if Square.rowsum x i <> 0.0
      then false
      else begin
	Square.swap_out_row x i;
	true
      end

let clearLosersMod x =
  let more = ref true in
    while !more do
      more := false;
      let onceThrough () = 
	for i = 0 to (Square.size x)-1 do
	  let next = clearLosersIter i x in 
	    more := !more || next
	done in
	onceThrough ();
	Square.transpose x;
	onceThrough ();
	Square.transpose x
    done
    
let clearLosers x =
  let y = Square.make x in
    clearLosersMod y;
    Square.snapshot y
    

let simplebad = 
  [|
    [|0.;1.|];
    [|0.;0.|]
  |]

(*
Cal 
Chico
Fullerton RS
Fullerton BG
Pepperdine
SLO
Redlands
Sac
SF EW
SF GS
UCLA
USC
*)

let d1qual2009 () = Array.map (Array.map float)
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

let d1qual2009nocal () = Array.map (Array.map float)
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
(*
let example1 = 
  [|[|0.0; 1.0; 0.9; 0.9|];
    [|1.0; 0.0; 0.9; 0.0|];
    [|0.1; 0.1; 0.0; 0.0|];
    [|0.1; 0.0; 0.0; 0.0|]|]

let example2 = 
  [|[|0.0; 1.0; 90.0; 0.9|];
    [|1.0; 0.0; 0.9; 0.0|];
    [|10.0; 0.1; 0.0; 0.0|];
    [|0.1; 0.0; 0.0; 0.0|]|]

let example3 = 
  [|[|0.0; 0.9; 90.0; 0.9|];
    [|1.1; 0.0; 0.9; 0.0|];
    [|10.0; 0.1; 0.0; 0.0|];
    [|0.1; 0.0; 0.0; 0.0|]|]

let example4 = 
  [|[|0.0; 100.0; 0.9; 0.9|];
    [|100.0; 0.0; 0.9; 0.0|];
    [|0.1; 0.1; 0.0; 0.0|];
    [|0.1; 0.0; 0.0; 0.0|]|]

let example5 = 
  [|[|0.0; 2.0; 1.8; 1.8|];
    [|2.0; 0.0; 0.9; 0.0|];
    [|0.2; 0.1; 0.0; 0.0|];
    [|0.2; 0.0; 0.0; 0.0|]|]

let footnote11a () = 
  [|[|0.0; 0.55; 9.0; 9.0|];
    [|0.45; 0.0; 5.0; 5.0|];
    [|1.0; 5.0; 0.0; 9.0|];
    [|1.0; 5.0; 1.0; 0.0|]|]

let footnote11b () = 
  [|[|0.0; 55.0; 9.0; 9.0|];
    [|45.0; 0.0; 5.0; 5.0|];
    [|1.0; 5.0; 0.0; 9.0|];
    [|1.0; 5.0; 1.0; 0.0|]|]
*)
      


(*
let array n f = Array.init n f

let matrix n f = array n (fun i -> (array n (fun j -> f i j)))

let sumArray x = Array.fold_left (+.) 0.0 x

let matrixCopy x = Array.map Array.copy x

let clearLosers' a r = 
  let n = Array.length !a in
  if n <= 1
  then false
  else 
    let drop = ref 0 in
      for i = 0 to n-1 - !drop do
        let sum = ref 0. in
          for j = 0 to n-1 - !drop do
            sum := !sum +. !a.(i).(j)
          done;
          if !sum = 0.
          then begin
            !a.(i) <- !a.(n-1 - !drop);
            for j = 0 to n-1 - !drop do
              !a.(j).(i) <- !a.(j).(n-1 - !drop)
            done;
            !r.(i) <- !r.(n-1 - !drop);
            drop := !drop + 1
          end
      done;
      if !drop > 0
      then
        let crop x = Array.sub x 0 (n - !drop) in
          r := crop !r;
          a := crop (Array.map crop !a);
          true
      else
        false

let transpose x = 
  let n = Array.length x in 
    for i = 0 to n-1 do
      for j = 0 to i-1 do
	let temp = x.(i).(j) in
          x.(i).(j) <- x.(j).(i);
	  x.(j).(i) <- temp
      done
    done

let clearLosersIter a r =
  let f = clearLosers' a r in
    transpose !a;
    let s = clearLosers' a r in
      transpose !a;
      f || s
      

let clearLosersOfCopy a r =
  while (clearLosersIter a r) do 
    ()
  done

let clearLosers a r = 
  let ap = ref (matrixCopy a) in
  let rp = ref (Array.copy r) in 
    clearLosersOfCopy ap rp;
    (!ap,!rp)
*)
