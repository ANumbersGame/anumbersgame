open WinsGraph
open ReadWinMatrix

let _,wins = fillWins ()

let _,arls,_ = sizedSccDag (fromMatrix (Array.length wins) wins)

let n = Array.length arls

let () = 
  print_int n;
  print_newline();
  for i = 0 to n-1 do
    print_int (List.length arls.(i));
    print_newline ()
  done
