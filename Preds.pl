requestt(X, Y) --> "Who is ", listt(X), " to ", listt(Y), "?".

requestt(X, Y) --> "Who is ", listt(X), "'s ", listt(Y), "?".

request(Str, Ans) :- phrase(requestt(X, Y), Str)
		     , makework(X, Y, Ans).
					 
makework(X, "brother", Ans) :- relative("brother", X, Ans).

makework(X, "sister", Ans) :- relative("sister", X, Ans).

makework(X, "son", Ans) :- parent(X, Ans), sex(Ans, m).

makework(X, "daughter", Ans) :- parent(X, Ans), sex(Ans, f).

makework(X, "father", Ans) :- parent(Ans, X), sex(Ans, m).

makework(X, "mother", Ans) :- parent(Ans, X), sex(Ans, f).

makework(X, Y, Ans) :- relative(Ans, X, Y).

listt([]) --> [].
   
listt([L|Ls]) --> [L], listt(Ls).

relative(Res, X, Y) :- var(Y)
		       , phrase_from_file(liness(S), 'NameBase.txt')
		       , getname(S, Num, X)
		       , string_codes(Res, RRes)
		       , append(RRes, " - ", PRes)
		       , solvebfs(Num, Num0, PromRess)
		       , reverse(PromRess, PromRes)
		       , getres(PromRes, [], PRes)
		       , getname(S, Num0, Y).
						
relative(Res, X, Y) :- var(X)
		       , phrase_from_file(liness(S), 'NameBase.txt')
		       , getname(S, Num0, Y)
		       , string_codes(Res, RRes)
		       , append(RRes, " - ", PRes)
		       , solvebfs(Num, Num0, PromRess)
		       , reverse(PromRess, PromRes)
		       , getres(PromRes, [], PRes)
		       , getname(S, Num, X).

relative(Res, X, Y) :- phrase_from_file(liness(S), 'NameBase.txt')
		       , getname(S, Num, X)
	               , getname(S, Num0, Y)
		       , solvebfs(Num, Num0, PromRess)
		       , reverse(PromRess, PromRes)
		       , getres(PromRes, [], PRes)
		       , append(RRes, " - ", PRes)
		       , string_codes(Res, RRes).
						
getres([X, Y | T], Prom, Res) :- pparent(X, Y)
				 , X \= Y
				 , ssex(X, G)
				 , ((G=m
				 , append(Prom, "father - ", Prom0)) ; (G=f), append(Prom, "mother - ", Prom0))
				 , getres([Y | T], Prom0, Res).
								 
getres([X, Y | T], Prom, Res) :- pparent(Y, X)
				 , X \= Y
				 , append(Prom, "child - ", Prom0)
				 , getres([Y | T], Prom0, Res).

getres([L], "child - father - ", "sister - ") :- ssex(L, f).
getres([L], "child - mother - ", "sister - ") :- ssex(L, f).
getres([L], "child - father - ", "brother - ") :- ssex(L, m).
getres([L], "child - mother - ", "brother - ") :- ssex(L, m).
getres([_], Res, Res).

parent(X, Y) :- nonvar(X), nonvar(Y), phrase_from_file(liness(S), 'NameBase.txt'), getname(S, Num, X), getname(S, Num0, Y), pparent(Num, Num0).
parent(X, Y) :- nonvar(X), phrase_from_file(liness(S), 'NameBase.txt'), getname(S, Num, X), pparent(Num, Num0), getname(S, Num0, Y).
parent(X, Y) :- nonvar(Y), phrase_from_file(liness(S), 'NameBase.txt'), getname(S, Num0, Y), pparent(Num, Num0), getname(S, Num, X).

sex(X, Y) :- nonvar(X), phrase_from_file(liness(S), 'NameBase.txt'), getname(S, Num, X), ssex(Num, Y), !.
sex(X, Y) :- nonvar(Y), phrase_from_file(liness(S), 'NameBase.txt'), ssex(Num, Y), getname(S, Num, X).

cousin(X, Y) :- nonvar(X)
		, nonvar(Y)
		, X \= Y
		, phrase_from_file(liness(S), 'NameBase.txt')
		, getname(S, Num, X)
		, pparent(NumP, Num)
		, NumP \= 0
		, getname(S, Num0, Y)
		, pparent(Num0P, Num0)
		, Num0P \= 0
		, pparent(NumGP, NumP)
		, NumGP \= 0
		, pparent(NumGP, Num0P)
		, !.
				
cousin(X, Y) :- nonvar(X)
		, phrase_from_file(liness(S), 'NameBase.txt')
		, getname(S, Num, X)
		, pparent(NumP, Num)
		, NumP \= 0
		, pparent(NumGP, NumP)
		, NumGP \= 0
		, pparent(NumGP, Num0P)
		, pparent(Num0P, Num0)
		, Num \= Num0
		, getname(S, Num0, Y)
		, sex(Y, m)
		.
				
cousin(X, Y) :- nonvar(Y)
		, sex(Y, m)
		, phrase_from_file(liness(S), 'NameBase.txt')
		, getname(S, Num0, Y)
		, pparent(Num0P, Num0)
		, Num0P \= 0
		, pparent(NumGP, Num0P)
		, NumGP \= 0
		, pparent(NumGP, NumP)
		, pparent(NumP, Num)
		, Num0 \= Num
		, getname(S, Num, X)
		.
				
getname([H|_], X, Res) :- phrase(basename(X, Prom), H), string_codes(Res, Prom).
getname([_|T], X, Res) :- getname(T, X, Res).

basename(X, Res) --> number(X), " ", list(Res), anything.

prepare :- [library(dcg/basics)]
	   , consult('HelpPreds.pl')
	   , consult('Genders.pl')
	   , consult('Base.pl')
	   .
