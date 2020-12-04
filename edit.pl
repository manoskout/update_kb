:-dynamic parent/2, father/2, mother/2.

parent(X,Y):-
    father(X,Y).

parent(X,Y):-
    mother(X,Y).

mother(eleni,anna).
mother(eleni,kostas).
father(yannis,maria).
father(kostas,petros).

abolish_mother:-
    abolish(mother/2).

eisagwgh_sthn_arxh(Knowledge):-
    format('~nWOW! Edwses epipleon gnwsh (mphke sthn arxh) : ~w ~n', [Knowledge]),nl,
    asserta(Knowledge).
eisagwgh_sto_telos(Knowledge):-
    format('~nWOW! Edwses pali epipleon gnwsh (mphke sto telos) : ~w ~n', [Knowledge]),nl,
    assertz(Knowledge).

afairesh_protasis(X):-
    format('~nWOW! Afaireses gnwsh : ~w ~n', [X]),nl,
    retract(X).

psakse_katigorima(X,Res):-
    clause(X,Res).