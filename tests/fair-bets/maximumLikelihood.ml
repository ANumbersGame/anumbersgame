(* 
This module implements the maximum likelihood estimation (MLE) model of team strength. It is also known as the Bradley-Terry model, Bradley-Terry-Luce, or the Zermelo model.
*)

open Format
open GetGraphDirect
open Gsl_cdf
module P = Pervasives
open Graph

(* 
A tournament graph is a set of nodes (one for each team) and directed edges between them. An edge from team i to team j is labelled with the number of times i beat j.
*)

module Vertex = struct
  type t = int
  let compare = P.compare
  let hash x = Hashtbl.hash x
  let equal x y = x=y
end

module G = Imperative.Digraph.Concrete (Vertex)

module C = Components.Make(G)
module I = Oper.I(G)

(* 

MLE traditionally only runs on strongly-connected components of a tournament graph. That is, if order to rate a set of teams S, for all pairs of teams x,y \in S, there must be a sequence a_0, a_1, . . ., a_n \in S such that a_0 = x, a_n = y, and \forall i, a_i beat a_{i+1}. This is sometimes described as:

For any partition of S into sets A, B, there is a team x \in A that beats some team y \in B.

On strongly connected components S, the traditional algorithm is guaranteed to converge. If S is not strongly connected, and there is some partition of S into A, B such that no team in A beats any team in B, then the traditional algorithm tends to send the team rating of every team B off to infinity (or the ratings in A toward 0).

I know of at least three ways to combat this:

1. Use recursive performance (RP) rather than maximum likelihood. This is a similar method that calculates the team ratings based on the average opponent. RP can rate some sets that MLE cannot, though MLE can also rate sets that RP cannot rate. For more detail, see "Ranking participants in tournaments by means of rating functions"

http://webs.uvigo.es/julio.gonzalez/Desempate/descargas_en.htm
http://scholar.google.com/scholar?cluster=1976262193035074609

2. Use a Bayesian approach to MLE. Since the probability of any team having infinite strength is 0, this prevents ratings heading off toward infinity. For more information on this approach, see "A Bayesian approach to paired comparison experimentation" and "An alternative Bayesian approach to the Bradley-Terry model for paired comparisons"

http://scholar.google.com/scholar?cluster=9345671314019302792&hl=en
http://scholar.google.com/scholar?cluster=13452865434629672334&hl=en

3. Assume teams are roughly equal in strength, as in the Bayesian approach, but take the limit of the ranking produced as the assumption decreases toward 0, as described in "An extension of Zermelo's model for ranking by paired comparisons". 

http://scholar.google.com/scholar?cluster=14353807758324199880

This will rate all teams at any tournament, but the meaning of the rating is not the same the meaning of MLE ratings. The ranking produced is consistent with MLE except possibly breaking ties in which the teams actually do have different (modulo team names) results. In cases where there is some partition of S into A and B such that no team in A beats any team in B, this method ranks every team in B higher than every team in A. This some sometimes explained as "respecting dominance", and is not a particularly good property for rating teams competing in individual debate tournaments; see http://repository.anumbersgame.net/wiki/TournamentCharts

*)

(*
A tournament matrix is a square matrix with the entry in the ith row and jth column representing the number of wins for i in i-j matches.

mkGraph turns a tournament matrix into a directed graph with positive weights on the edges.
*)
let mkGraph d =   
  let g = G.create () in
  let n = Array.length d in
    for i = 0 to n-1 do
      for j = 0 to n-1 do
	if d.(i).(j) > 0.0
	then G.add_edge g i j
      done
    done;
    g


(*
submats takes a tournament matrix and returns an array in which each element represents a strongly connected component, or "league". The representation of a league is a list of the team numbers followed by its adjacency matrix.

These leagues are the individual objects on which we perform MLE.
*)

let submats mat =
  let g = mkGraph mat in 
  let h = C.scc_array g in
  let n = Array.length h in
  let ans = Array.make n ([], Array.make_matrix 0 0 0.0) in
    for i = 0 to n-1 do
      let alist = h.(i) in
      let m = List.length alist in
      let amat = Array.make_matrix m m 0.0 in
        for j = 0 to m-1 do
          for k = 0 to m-1 do
	    let lof x = List.nth alist x in
              amat.(j).(k) <- mat.(lof j).(lof k)
          done
        done;
        ans.(i) <- (alist, amat)
    done;
    ans

(*
To calculate the MLE, use the MM method described in 

"MM algorithms for generalized Bradley-Terry models"

http://scholar.google.com/scholar?cluster=1036704245272414243

This is the non-cyclic version of the algorithm, to ensure no strange interactions with renormalization. I don't think this is actually a problem with the cyclic version, but I wanted to be careful.

*)

let prod x = Array.fold_left (fun y z -> y *. z) 1.0 x

let rec normalize x = 
  let s = prod x in
    if s = 0.0
    then
      normalize (Array.map (fun v -> 2.0 *. v) x)
    else begin
      let n = Array.length x in
      let v = s ** (1.0 /. (float n)) in
	Array.iteri (fun i y -> x.(i) <- y /. v) x;
	x
    end

let sum x = Array.fold_left (fun y z -> y +. z) 0.0 x

let norm1 x = 
  let s = sum x in
    Array.iteri (fun i y -> x.(i) <- y /. s) x

let maxLikely a eps =
  let magnitude x = Array.fold_left (fun y z -> max y z) 0.0 (Array.map abs_float x) in
  let wins = Array.map sum a in
  let n = Array.length a in
  let gamma = ref (Array.make n 1.0) in
  let newgamma = Array.make n 1.0 in
  let lastChange = ref (1.0 /. (float n)) in
    while !lastChange > eps do
      for i = 0 to n-1 do
	let nn = sum (Array.mapi (fun j gj -> (a.(i).(j) +. a.(j).(i))/.(!gamma.(i) +. gj)) !gamma) in
	  newgamma.(i) <- wins.(i) /. nn;
      done;
      norm1 newgamma;
      let diffs = Array.mapi (fun i v -> log v -. log !gamma.(i)) newgamma in
	lastChange := magnitude diffs;
	gamma := Array.copy newgamma
    done;
    !lastChange, normalize !gamma

(*
The natural log of the likelihood of tournament results m under a particular ratings vector r. The higher this number, the better the ratings are.
*)
let loglikelihood m r =
  let n = Array.length m in
  let ans = ref 0.0 in
    for i = 0 to n-1 do
      for j = 0 to n-1 do
	ans := !ans +. m.(i).(j) *. log (r.(i)/.(r.(i) +. r.(j)))
      done
    done;
    !ans

(*
The likelihood that the strengths are an exact match, as given in "Science, statistics, and paired comparisons"

http://scholar.google.com/scholar?cluster=11643095567770383519

"On extending the Bradley-Terry model to accommodate ties in paired comparison experiments"

http://scholar.google.com/scholar?cluster=7657741521898077715

It returns a pair of the likelihood the the model is a perfect fit and the likelihood that it is imperfect.

This goodness of fit statistic is only valid when each pair of teams debates a large number of times.

*)
let appropriateness m r =
  let n = Array.length m in
  let ans = ref 0.0 in
    for i = 0 to n-1 do
      for j = 0 to n-1 do
	if m.(i).(j) > 0.0
	then 
	  ans := !ans +. m.(i).(j) *. log (m.(i).(j)/.((m.(i).(j) +. m.(j).(i)) *. (r.(i)/.(r.(i)+.r.(j)))))
      done
    done;
    let d = float n in
    let dof = d*.(d-.1.0)/.2.0 -. d +. 1.0 in
      chisq_P ~x:(2.0 *. !ans) ~nu:dof, chisq_Q ~x:(2.0 *. !ans) ~nu:dof

(*

To test if there is any side bias, we can use the home-field advantage/presentation order bias tests, as described in "On extending the Bradley-Terry model to incorporate within-pair order effects"

http://scholar.google.com/scholar?cluster=6050716066748286974

or the MM paper mentioned above ("MM algorithms for generalized Bradley-Terry models").

*)

(*

MLE with side bias required two graphs as input. Both graphs give every team a node. One graph has an edge from i to j labelled m iff i beat j m times when i was aff. The other graph has an edge from i to j labelled m iff i lost to j m times when i was aff. MLE with side bias is only guaranteed to converge if both graphs are strongly connected.

subHome2 finds the components that are strongly connected by finding a fixed point of a function that find the SCCs in the second graph of the SCCs of the first graph, then switching the order of the graphs.


*)

let rec subHome2help ?(final=true) hwin hlos =
  let gw = mkGraph hwin in
  let h = C.scc_array gw in
  let n = Array.length h in
    if (n = 1) && (List.length h.(0) = Array.length hwin)
    then 
      if final
      then Array.make 1 (List.sort P.compare h.(0), hwin, hlos)
      else Array.map (fun (r,l,w) -> r,w,l) (subHome2help hlos hwin)
    else
      let ans = ref (Array.make 0 ([], Array.make_matrix 0 0 0.0, Array.make_matrix 0 0 0.0)) in
	for i = 0 to n-1 do
	  let alist = h.(i) in
	  let m = List.length alist in
	  let matw = Array.make_matrix m m 0.0 in
	  let matl = Array.make_matrix m m 0.0 in
            for j = 0 to m-1 do 
	      let lj = List.nth alist j in
		for k = 0 to m-1 do 
		  let lk = List.nth alist k in
		  let winsize = Array.length hwin in
		  let lossize = Array.length hlos in
		    if lj < winsize && lk < winsize
		    then matw.(j).(k) <- hwin.(lj).(lk);
		    if lj < lossize && lk < lossize
		    then matl.(j).(k) <- hlos.(lj).(lk)
		done
            done;
	    let interf (iss, ll, ww) =
	      let lmap = List.map (List.nth alist) iss 
	      in lmap, ww, ll
	    in
	    let inter = Array.map interf (subHome2help matl matw) in
	      ans := Array.append !ans inter
	done;
	!ans

(*
In the first iteration, the second graph has not yet even been inspected.
*)

let subHome2 w l = subHome2help ~final:false w l

(*
subHome3 does the same thing, but is very slow.
*)

(*
let subHome3 hwin hlos =
  let gw = mkGraph hwin in
  let gl = mkGraph hlos in
  let gw2 = I.transitive_closure gw in
  let gl2 = I.transitive_closure gl in
  let glw = I.intersect gw gl2 in
  let h = C.scc_array glw in
  let n = Array.length h in
  let ans = Array.make n ([], Array.make_matrix 0 0 0.0, Array.make_matrix 0 0 0.0) in
    for i = 0 to n-1 do
      let alist = h.(i) in
      let m = List.length alist in
      let wmat = Array.make_matrix m m 0.0 in
      let lmat = Array.make_matrix m m 0.0 in
        for j = 0 to m-1 do
          for k = 0 to m-1 do
	    let lof x = List.nth alist x in
	      wmat.(j).(k) <- hwin.(lof j).(lof k);
	      lmat.(j).(k) <- hlos.(lof j).(lof k)
          done
        done;
        ans.(i) <- (alist, wmat, lmat)
    done;
    ans
*)

(*

Calculated the MLE with side bias using the MM algorithm mentioned above.

*)

let maxHome a b eps =
  let magnitude z x =  max z (Array.fold_left (fun p q -> max p q) 0.0 (Array.map abs_float x)) in
  let winsA = Array.map sum a in
  let n = Array.length a in
  let winsB = Array.make n 0.0 in
    for i = 0 to n-1 do
      for j = 0 to n-1 do
	winsB.(j) <- winsB.(j) +. b.(i).(j)
      done 
    done;
    let h = sum winsA in
    let omega = ref 1.0 in
    let newmega = ref 1.0 in
    let gamma = ref (Array.make n 1.0) in
    let newgamma = Array.make n 1.0 in
    let lastChange = ref 1.0 in
      while !lastChange > eps do
	let mm = ref 0.0 in
	  for i = 0 to n-1 do
	    let nn = ref 0.0 in
	      for j = 0 to n-1 do
		nn := !nn +. (a.(i).(j) +. b.(i).(j)) *. !omega     /. (!omega *. !gamma.(i) +. !gamma.(j));
		nn := !nn +. (a.(j).(i) +. b.(j).(i))               /. (!omega *. !gamma.(j) +. !gamma.(i));
		mm := !mm +. (a.(i).(j) +. b.(i).(j)) *. !gamma.(i) /. (!omega *. !gamma.(i) +. !gamma.(j))
	      done;
	      newgamma.(i) <- (winsA.(i) +. winsB.(i)) /. !nn
	  done;
	  newmega := h /. !mm;
	  norm1 newgamma;
	  let diffs = Array.mapi (fun i v -> log v -. log !gamma.(i)) newgamma in
	    lastChange := magnitude (log !newmega -. log !omega) diffs;
	    gamma := Array.copy newgamma;
	    omega := !newmega
      done;
      !lastChange, !omega, normalize !gamma
	

let logHomelikelihood w l theta r =
  let n = Array.length w in
  let ans = ref 0.0 in
    for i = 0 to n-1 do
      for j = 0 to n-1 do
	ans := !ans +. w.(i).(j) *. log ((theta *. r.(i))/.((theta *. r.(i)) +. r.(j)));
	ans := !ans +. l.(i).(j) *. log (r.(j)/.((theta *. r.(i)) +. r.(j)));
      done
    done;
    !ans

let logHomelikelihoodDiff w l theta r conte g =
  let n = Array.length w in
  let ans = ref 0.0 in
    for i = 0 to n-1 do
      for j = 0 to n-1 do
	ans := !ans +. w.(i).(j) *. log (((theta *. r.(i))/.((theta *. r.(i)) +. r.(j)))/.((conte *. g.(i))/.((conte *. g.(i)) +. g.(j))));
	ans := !ans +. l.(i).(j) *. log ((r.(j)/.((theta *. r.(i)) +. r.(j)))/.(g.(j)/.((conte *. g.(i)) +. g.(j))));
      done
    done;
    !ans

(*
This goodness of fit statistic is only valid when each pair of teams debates a large number of times.
*)
let appropriatenessHome w l theta r =
  let n = Array.length w in
  let ans = ref 0.0 in
    for i = 0 to n-1 do
      for j = 0 to n-1 do
	if w.(i).(j) > 0.0
	then ans := !ans +. w.(i).(j) *. log (w.(i).(j)/.((w.(i).(j) +. l.(i).(j)) *. ((theta *. r.(i))/.((theta *. r.(i))+.r.(j)))));
	if l.(i).(j) > 0.0
	then ans := !ans +. l.(i).(j) *. log (l.(i).(j)/.((w.(i).(j) +. l.(i).(j)) *. (r.(j)/.((theta *. r.(i))+.r.(j)))));
      done
    done;
    2.0 *. !ans
      
let maxHomeFix t a b eps =
  let magnitude x =  Array.fold_left (fun p q -> max p q) 0.0 (Array.map abs_float x) in
  let winsA = Array.map sum a in
  let n = Array.length a in
  let winsB = Array.make n 0.0 in
    for i = 0 to n-1 do
      for j = 0 to n-1 do
	winsB.(j) <- winsB.(j) +. b.(i).(j)
      done 
    done;
    let gamma = ref (Array.make n 1.0) in
    let newgamma = Array.make n 1.0 in
    let lastChange = ref 1.0 in
      while !lastChange > eps do
	for i = 0 to n-1 do
	  let nn = ref 0.0 in
	    for j = 0 to n-1 do
	      nn := !nn +. (a.(i).(j) +. b.(i).(j)) *. t /. (t *. !gamma.(i) +. !gamma.(j));
	      nn := !nn +. (a.(j).(i) +. b.(j).(i))      /. (t *. !gamma.(j) +. !gamma.(i));
	    done;
	    newgamma.(i) <- (winsA.(i) +. winsB.(i)) /. !nn
	done;
	norm1 newgamma;
	let diffs = Array.mapi (fun i v -> log v -. log !gamma.(i)) newgamma in
	  lastChange := magnitude diffs;
	  gamma := Array.copy newgamma;
      done;
      !lastChange, normalize !gamma

let rec slopeHomeLikely a b theta r eps like delt =
  let t = log theta in
  let tlo = t -. delt in
  let thi = t +. delt in
  let oper v = 
    let _,ans = maxHomeFix (exp v) a b eps in
      logHomelikelihoodDiff a b theta r (exp v) ans
  in
  let tlolik,thilik = oper tlo, oper thi in
  let sloplo = tlolik /. delt in
  let slophi = -. thilik /. delt in
    printf "t: %g\n" t;
    printf "delt: %g\n" delt;
    printf "tlo: %g\n" tlo;
    printf "thi: %g\n" thi;
    printf "tlolik: %g\n" tlolik;
    printf "thilik: %g\n" thilik;
    printf "sloplo: %g\n" sloplo;
    printf "slophi: %g\n" slophi;
    if (sloplo <= 0.0) || (slophi >= 0.0)
    then slopeHomeLikely a b theta r eps like (2.0 *. delt)
    else sqrt(delt /. (sloplo -. slophi)),delt

let rec findInterval tlo thi a b eps theta r like oth g ll =
  if oth = theta
  then begin
    let newoth = oth +. 0.1 in
    let _,newg = maxHomeFix newoth a b eps in
    let newll = logHomelikelihood a b newoth newg in
      findInterval tlo thi a b eps theta r like newoth newg newll
  end else begin
    if ll > thi
    then begin
      printf "too close: %g\n" oth;
      flush stdout; (*
		      print_string "too high: ";
		      print_float oth;
		      print_newline ();
		      flush stdout; *)
      let newoth = oth -. (theta -. oth) in
      let _,newg = maxHomeFix newoth a b eps in
      let newll = logHomelikelihood a b newoth newg in
	findInterval tlo thi a b eps theta r like newoth newg newll
    end else begin
      if ll < tlo
      then begin
	printf "too far: %g\n" oth;
	flush stdout;
	let newoth = theta +. (oth -. theta)/.2.0 in
	let _,newg = maxHomeFix newoth a b eps in
	let newll = logHomelikelihood a b newoth newg in
	  if newll > thi
	  then findInterval tlo thi a b eps newoth newg newll oth g ll
	  else begin
	    if newll < tlo
	    then findInterval tlo thi a b eps theta r like newoth newg newll
	    else begin 
	      printf "ok: %g\n" newoth;
	      flush stdout;
	      newll, newoth, newg
	    end
	  end
      end else begin
	printf "ok: %g\n" oth;
	flush stdout;
	ll,oth,g
      end
    end
  end

let epsilon = 1.0e-9

let () = 
  for year = 2004 to 2009 do 
    let (t,w,l,n) = balance year in
      print_endline "year:";
      print_int year;
      print_newline ();
      let subm = subHome2 w l in
      let getranks (n,aw,al) = 
	let m = List.length n in
	let full = Array.make_matrix m m 0.0 in
	  for i = 0 to m-1 do
	    let ii = List.nth n i in
	      for j = 0 to m-1 do
		full.(i).(j) <- t.(ii).(List.nth n j)
	      done
	  done;
	  n,full,aw,al,maxLikely full epsilon, maxHome aw al epsilon
      in
      let answers = Array.map getranks subm in
      let many = Array.length answers in
	for i = 0 to many-1 do
	  let noms,full,aw,al,(neweps,ranks),(newHomeeps,theta,gamma) = answers.(i) in
	  let ll = loglikelihood full ranks in
	  let lh = logHomelikelihood aw al theta gamma in (*
	  let logthetasd,_ = slopeHomeLikely aw al theta gamma epsilon lh (2.0 *. epsilon) in *)
	  let bhi = lh -. (chisq_Pinv 0.89 1.0)/.2.0 in
	  let blo = lh -. (chisq_Pinv 0.91 1.0)/.2.0 in
	  let lll,oth,_ = findInterval blo bhi aw al epsilon theta gamma lh 1.0 ranks ll in
	  let opp = exp (log theta +. (log theta -. log oth)) in
	  let _,newg = maxHomeFix opp aw al epsilon in
	  let newll = logHomelikelihood aw al opp newg in
	  let l4,o4,_ = findInterval blo bhi aw al epsilon theta gamma lh opp newg newll in
	    printf "number of teams: %i\n" (List.length noms);
	    printf "epsilon: %g\n" epsilon;
	    printf "new epsilon: %g\n" neweps;
	    printf "new home epsilon: %g\n" newHomeeps;
	    printf "aff bias: %g\nneg bias: %g\n" theta (1.0/.theta);
	    printf "likelihoods %g %g %g\n" lh lll l4;
	    flush stdout;
	    printf "toward-zero %g%%: %g %g\n" (100.0 *. chisq_P (2.0 *. (lh -. lll)) 1.0) oth (1.0/.oth);
	    printf "away-zero %g%%: %g %g\n" (100.0 *. chisq_P (2.0 *. (lh -. l4)) 1.0) o4 (1.0/.o4);
	    printf "simple log likelihood: %g\n" ll;
	    printf "biased log likelihood: %g\n" lh;
	    printf "Twice difference of log likelihood: %g\n" (2.0 *. (lh -. ll));
	    flush stdout;
	    printf "probability of bias: %g\n" (chisq_P (2.0 *. (lh -. ll)) 1.0); 
	    printf "probability of non-bias: %g\n" (chisq_Q (2.0 *. (lh -. ll)) 1.0); 
	    printf "inverse probability of non-bias: %g\n" (1.0/.(chisq_Q (2.0 *. (lh -. ll)) 1.0)); 
	    printf "natural log of inverse probability of non-bias: %g\n" (-.log (chisq_Q (2.0 *. (lh -. ll)) 1.0)); 
	    printf "log base 10 of inverse probability of non-bias: %g\n" ((-.log (chisq_Q (2.0 *. (lh -. ll)) 1.0))/.(log 10.0)); (*
	    printf "standard deviation around natural log bias: %g\n" logthetasd;
            printf "2sd confidence interval: (%g,%g)\n" (exp(log(theta) -. 2.0 *. logthetasd)) (exp(log(theta) +. 2.0 *. logthetasd)); *)
	    let pairup i x = (x,n.(List.nth noms i)) in
	    let basic = Array.mapi pairup ranks in
	    let turn = Array.mapi pairup gamma in
	    let comp a b = - P.compare a b in
	      Array.sort comp basic;
	      Array.sort comp turn;
	      printf "|| *team* || *simple ranking* || *side-corrected ranking* || *team* ||\n";
	      for j = 0 to min 7 (Array.length basic -1) do
		let lr,ln = basic.(j) in
		let rr,rn = turn.(j) in
		  printf "||%s\t||%f\t||%f\t||%s\t||\n" ln lr rr rn
	      done
	done
  done
    
    
