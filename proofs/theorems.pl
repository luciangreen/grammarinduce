% Theorems, proved by exhaustion. Run: swipl -g main -t halt proofs/theorems.pl
:- module(theorems, [main/0]).
:- use_module(prove).
:- discontiguous theorem/1.
:- use_module(library(lists)).
:- use_module(library(apply)).
main :- prove_all(theorems).
:- use_module('../prolog/grammarinduce').

% Domain: every set of 1..3 distinct sentences of length 1..2 over the words a, b.
sentence_d(S) :- between(1, 2, N), length(S, N), maplist([W]>>member(W, [a, b]), S).
training(T) :- findall(S, sentence_d(S), All), between(1, 3, K), length(T, K), pick(T, All).
pick([], _).
pick([X|Xs], [Y|Ys]) :- ( X = Y, pick(Xs, Ys) ; pick([X|Xs], Ys) ).

% 1. The grammar parses every training sentence.
theorem(parses_training) :- forall(training(T), ( induce(T, G), forall(member(S, T), parses(G, S)) )).

% 2. Every entry is needed: drop one and some training sentence stops parsing.
theorem(every_entry_needed) :- forall(training(T), ( induce(T, grammar(Lex)), forall(select(_, Lex, Rest), ( member(S, T), \+ parses(grammar(Rest), S) )) )).

% 3. The language contains the training set, and its size is the sum over lengths of the product of slot sizes.
theorem(language_is_slot_product) :- forall(training(T), ( induce(T, G), language(G, Lang), subtract(T, Lang, []), G = grammar(Lex), findall(L, member(slot(L, _)-_, Lex), L0), sort(L0, Ls), foldl([L, A0, A]>>( numlist(1, L, Is), foldl([I, P0, P]>>( aggregate_all(count, member(slot(L, I)-_, Lex), C), P is P0 * C ), Is, 1, Pr), A is A0 + Pr ), Ls, 0, Size), length(Lang, Size) )).

% 4. The order of the examples does not matter.
theorem(order_independent) :- forall(training(T), ( induce(T, G), forall(permutation(T, P), induce(P, G)) )).
