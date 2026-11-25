# grammarinduce

learn a grammar from example sentences and parse with it as a DCG. Each word is filed under the slot it filled (sentence length and position); a sentence is in the language when its length was seen and each word was seen in its slot. Words that share exactly the same slots form a category. The grammar always parses every training sentence, every entry is needed by some sentence, and the order of the examples does not matter.

## Use

```prolog
?- use_module(prolog/grammarinduce).
?- induce([[the, cat, sleeps], [a, dog, runs]], G), parses(G, [the, dog, runs]).   % true
?- induce([[the, cat, sleeps], [a, dog, runs]], G), categories(G, C).
%  C = [[slot(3,1)]-[a, the], [slot(3,2)]-[cat, dog], [slot(3,3)]-[runs, sleeps]]
```

## Proofs

`proofs/theorems.pl` proves 4 theorems by exhaustion: each one is checked for every case in a finite domain that covers every branch of the definitions. every set of 1..3 distinct sentences of length 1..2 over the words a, b.

1. The grammar parses every training sentence.
2. Every entry is needed: drop one and some training sentence stops parsing.
3. The language contains the training set, and its size is the sum over lengths of the product of slot sizes.
4. The order of the examples does not matter.

```sh
swipl -g main -t halt proofs/theorems.pl
```

## 200 inputs and outputs

`io/ios.txt` lists 200 inputs and outputs from real runs, and `io/ios.pl` has the same as Prolog facts. The inputs come from a fixed seed (`io/cases.pl`). `swipl -g check -t halt io/run.pl` runs them again. It fails if any output changes, or if a predicate doesn't confirm its own recorded output, which checks steadfastness. GitHub Actions runs the proofs and the examples on every push, and records the examples on the first push.

Licence: BSD-3-Clause.
