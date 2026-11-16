:- module(cases, [title/1, case/3]).
:- use_module('../prolog/grammarinduce').
:- use_module(engine).
title('grammarinduce').
sent_g(S) :- rnd_int(2, 4, N), ( N =:= 2 -> rnd_pick([[birds, sing], [logic, works], [music, plays]], S) ; N =:= 3 -> rnd_pick([the, a, every], D), rnd_pick([cat, dog, student, robot], Nn), rnd_pick([sleeps, runs, thinks], V), S = [D, Nn, V] ; rnd_pick([the, a], D), rnd_pick([cat, dog, robot], Nn), rnd_pick([reads, writes], V), rnd_pick([books, code], O), S = [D, Nn, V, O] ).
sents_g(Ss) :- rnd_int(1, 5, K), length(Ss, K), maplist(sent_g, Ss).
case(induce, [Ss], induce) :- sents_g(Ss).
case(categories, [G], categories) :- sents_g(Ss), induce(Ss, G).
case(parses, [G, S], parses) :- sents_g(Ss), induce(Ss, G), sent_g(S).
