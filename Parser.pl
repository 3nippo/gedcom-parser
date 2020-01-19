
work :- [library(dcg/basics)]
	, consult('HelpPreds.pl')
	, set_prolog_stack(global, limit(100 000 000 000))
	, phrase_from_file(liness(Ls), 'royal.ged')
	, names(Ls)
	, sexs(Ls)
	, preds(Ls)
	.

sexs(Ls) :- open('Genders.pl', write, Stream)
	    , write(Stream, 'ssex(0, x).')
	    , nl(Stream)
	    , sex(Ls, Stream)
	    , close(Stream).
		 
sex([], _) :- !.
sex([H|T], Stream) :- phrase(ifindi(X), H), takesex([H|T], Stream, X), !.
sex([_|T], Stream) :- sex(T, Stream), !.

takesex([H|T], S, Indi) :- phrase(sexx(N), H)
			   , string_codes(Sex, [N])
			   , write(S, 'ssex(')
			   , write(S, Indi)
			   , write(S, ', ')
			   , write(S, Sex)
			   , write(S, ').')
			   , nl(S)
			   , sex(T, S).
takesex([_|T], S, X) :- takesex(T, S, X).

sexx(S) --> "1 SEX ", char(S), [10].

char(N) --> [N0], {member(N0, [77, 70]), N is N0+32}. 

names(Ls) :- open('NameBase.txt', write, Stream) 
	     , write(Stream, '0 unnamed')
	     , nl(Stream)
	     , name(Ls, Stream)
	     , close(Stream).

preds(Ls) :- open('Base.pl', write, Stream)
	     , phrase_from_file(lines(Stream1), 'NameBase.txt')
	     , makepreds(Ls, Stream, Stream1)
	     , close(Stream).

makepreds([], _, _) :- !.
makepreds([H|T], S, S1) :- (phrase(hus(_), H) ; phrase(wif(_), H)), takehusb([H|T], [], S, S1), !.
makepreds([_|T], S, S1) :- makepreds(T, S, S1).

takehusb([H|T], Fam, S, S1) :- phrase(hus(X), H), append(Fam, [X], Fam0), takewife(T, Fam0, S, S1), !.
takehusb([H|T], Fam, S, S1) :- X=0, append(Fam, [X], Fam0), takewife([H|T], Fam0, S, S1).

takewife([H|T], Fam, S, S1) :- phrase(wif(X), H), append(Fam, [X], Fam0), takechild(T, [], Fam0, S, S1), !.
takewife([H|T], Fam, S, S1) :- X=0, append(Fam, [X], Fam0), takechild([H|T], [], Fam0, S, S1).

takechild([H|T], Last, Fam, S, S1) :- phrase(chi(X), H), append(Last, [X], Last0), takechild(T, Last0, Fam, S, S1), !.
takechild(List, Last, Fam, S, S1) :- append(Fam, [Last], Res), writeres(S, S1, Res), makepreds(List, S, S1).

writeres(_, _, [_, _, []]) :- !.

writeres(S, S1, [Husb, Wife, [Chil|T]]) :- write(S, 'pparent(')
					   , write(S, Husb)
					   , write(S, ', ')
					   , write(S, Chil)
					   , write(S, ').')
					   , nl(S)
					   , write(S, 'pparent(')
					   , write(S, Wife)
					   , write(S, ', ')
					   , write(S, Chil)
					   , write(S, ').')
					   , nl(S)
					   , writeres(S, S1, [Husb, Wife, T]).

hus(X) --> "1 HUSB @I", number(X), "@", [10].
wif(X) --> "1 WIFE @I", number(X), "@", [10].
chi(X) --> "1 CHIL @I", number(X), "@", [10]. 

ifindi(X) --> "0 @I", number(X), "@ INDI", [10].

name([], _) :- !.
name([H|T], Stream) :- phrase(ifindi(X), H), takename(T, Stream, X), !.
name([_|T], Stream) :- name(T, Stream), !.

takename([H|T], Stream, Indi) :- phrase(namee(Name), H)
				 , string_codes(Namee, Name)
				 , write(Stream, Indi)
				 , write(Stream, ' ')
				 , write(Stream, Namee)
				 , nl(Stream)
				 , name(T, Stream).

namee(Name) --> "1 NAME ", list(Name), anything.
