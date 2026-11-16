% grammarinduce: learn a grammar from example sentences and parse with it as a DCG. Each word is
% filed under the slot it filled (sentence length and position); a sentence is in the language
% when its length was seen and each word was seen in its slot. Words that share exactly the same
% slots form a category. The grammar always parses every training sentence, every entry is
% needed by some sentence, and the order of the examples does not matter.
%?- induce([[the, cat, sleeps], [a, dog, runs]], G), parses(G, [the, dog, runs]).   % true
%?- induce([[the, cat, sleeps], [a, dog, runs]], G), categories(G, C).
%   C = [[slot(3,1)]-[a, the], [slot(3,2)]-[cat, dog], [slot(3,3)]-[runs, sleeps]]
:- module(grammarinduce, [induce/2, parses/2, language/2, categories/2, sentence//1]).
:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(pairs)).

induce(Sents, grammar(Lex)) :- findall(slot(L, I)-W, ( member(S, Sents), length(S, L), nth1(I, S, W) ), Ps), sort(Ps, Lex).

lengths(grammar(Lex), Ls) :- findall(L, member(slot(L, _)-_, Lex), L0), sort(L0, Ls).
sentence(G) --> { lengths(G, Ls), member(L, Ls) }, slots(G, L, 1).
slots(_, L, I) --> { I > L }, !, [].
slots(G, L, I) --> [W], { G = grammar(Lex), member(slot(L, I)-W, Lex), I2 is I + 1 }, slots(G, L, I2).

parses(G, Ws) :- once(phrase(sentence(G), Ws)).
language(G, Sents) :- findall(S, phrase(sentence(G), S), S0), sort(S0, Sents).

categories(grammar(Lex), Cats) :- findall(W, member(_-W, Lex), W0), sort(W0, Ws), findall(Slots-W, ( member(W, Ws), findall(S, member(S-W, Lex), Slots) ), P), keysort(P, KP), group_pairs_by_key(KP, Cats).
