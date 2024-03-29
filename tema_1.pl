
/*Returneaza un numar aleator intre 0 si mai mic decat NMax
in X
random_s(+Nmax, -X)*/
random_s(Nmax, X):- X is random(Nmax).

/*pop_queue(+[H|L]m -L, -H)*/
pop_queue([H|L], L, H).

/*isEmpty(+L)*/
isEmpty([]).

/*Verifica daca X exista in lista
exist(+L, -X)
*/
exist([H|_], X):-H=X.
exist([_|L], X):-exist(L, X).

/*Returneaza lungimea listei L
get_list_len(+L, -R)
*/
get_list_len([], 0).
get_list_len([_|L], R):-get_list_len(L, R1), R is R1 + 1.

/*Primeste ca argument doua liste si returneaza reuniunea intre acestea
insertOnce(+L1, +L2, -R)
*/
insertOnce([], L, L).
insertOnce([H|L], L2, R):-exist(L2, H), insertOnce(L, L2, R).
insertOnce([H|L], L2, R):-not(exist(L2, H)), insertOnce(L, [H|L2], R).

/*Sterge elementul egal cu X din lista
deleteVal(+X, +L, -R
*/
deleteVal(_, [], R):- R = [].
deleteVal(X, [H|L], R):- X \= H, deleteVal(X, L, R1), R = [H | R1].
deleteVal(X, [H|L], R):- X = H , deleteVal(X, L, R).

/*Insereaza elementul X pe pozitia Pos in lista L
insertOnPos(+L, +X, +Pos, -R)
*/
insertOnPos([_|L], X, 0, R):-R = [X|L].
insertOnPos([H|L], X, Pos, R):-
	TmpPos is Pos - 1,
	insertOnPos(L, X, TmpPos, RStack),
	R = [H|RStack].
/*Sterge elementul depe pozitia Pos
deleteOnPos(+L, +Pos, -L
*/
deleteOnPos([_|L], 0, L).
deleteOnPos([H|L], Pos, R):-
	TmpPos is Pos-1,
	deleteOnPos(L, TmpPos, RStack),
	R = [H|RStack].

find_elem(H, [H|_]).
find_elem(X, [_|L]):-find_elem(X, L).


f_max(X, Y, Max):-X > Y, Max = X.
f_max(X, Y, Max):-X =< Y, Max = Y.

f_abs(X, Y, R):-X >= Y, R is X - Y.
f_abs(X, Y, R):-X < Y, R is Y - X.

modul_pos(X, R):- X>=0, R is X.
modul_pos(X, R):- X < 0, R is 0.

/*Returneaza Elementula al Pos-lea din lista in variabila R
get_element(+L, +Pos, -R)*/
get_element([H|_], 0, R):-R = H.
get_element([_|L], Pos, R):-
	NextPos is Pos-1, get_element(L, NextPos, R).

/*Verifica daca elementul E se gaseste in lista
  list_contain(+E, +L)
 */
list_contain(E, [H|_]):- E = H.
list_contain(E, [_|L]):- list_contain(E, L).


/* BFS---------------------------------*/
get_index(X, [[X, _]|_], R, R).
get_index(X, [_|L], Acc, R):-Acc2 is Acc + 1, get_index(X, L, Acc2, R).


getFromPos(0, [[X, _]|_], X).
getFromPos(Pos, [_|L], R):-NewPos is Pos -1, getFromPos(NewPos, L, R).

/*Initializeaza Lista de parinti, primeste numarul de elemente
bfs_init_parent(+Nr, -L)
*/
bfs_init_parent(0, []).
bfs_init_parent(Nr, R):-
	TmpNr is Nr-1,
	bfs_init_parent(TmpNr, TmpR),
	append(TmpR, [-1], R).


/*Reface calea in functie de lista de parinti
Node - nodul curent in timpul recursivitatii
S - nodul sursa
Parent - lista de parinti
L - lista de vecini
PrevList - acumulator,
bfs_reproduce_way(+Node, +S, +Parent, +L,  +PrevList, -R)*/
bfs_reproduce_way(S, S, _, _, R, R).
bfs_reproduce_way(Node, S, Parent, L,  PrevList, R):-
	append(PrevList, [Node], NewList),
	get_index(Node, L, 0, Ind),
	get_element(Parent, Ind, NextNodeInd),
	getFromPos(NextNodeInd, L, NextNode),
	bfs_reproduce_way(NextNode, S, Parent,L , NewList, R).

/*Sterge elementele din L2 care se regasesc in L1
deleteList(+L1, +L2, -R)
*/
deleteList([], L, L).
deleteList([H|L], L2, R):-deleteVal(H, L2, LR), deleteList(L, LR, R).

/*
Sterge elementele din L1 care se regasesc in L2
Acelasi lucru ca deleteList dar foloseste stiva
extract(+L1, +l2, -R)
*/
extract(L, [], L).
extract(L1, [H|L2], R):-
	deleteVal(H, L1, Extr),
	extract(Extr, L2, RStack),
	R = RStack.

/*Adauga parintele unui element in lista de parinti
*/
mergeToParent([], _, Parent, _, Parent).
mergeToParent([H|L], P, ParentVect, G,  R):-
	mergeToParent(L, P, ParentVect, G, RStack),
	get_index(H, G, 0, Ind),
	insertOnPos(RStack, P, Ind, R).

/*Returneaza o lista cu vecinii unui element
*/
get_neigh(X, [[X, R]|_], R).
get_neigh(X, [_|L], R):-get_neigh(X, L, R).

/**
Functia recursiva care parcurge elementele din teritoriu
pentru a gasi calea cea mai scurta
*/
bfs_main_rec(_, _, _, _, [], _, _, -1).
bfs_main_rec(Node, _, _, Node, _, _,Sol, Sol).
bfs_main_rec(Node, L, F, D, Q, Viz, Parent, Sol):-
	get_neigh(Node, L, Neigh), !,
	extract(Neigh, F, ExtrF),
	extract(ExtrF, Viz, Extr),
	get_index(Node, L, 0, NodeIndex),
	mergeToParent(Extr, NodeIndex, Parent, L,  NewParent),
	append(Q, Extr, Q2),
	deleteOnPos(Q2, 0, Q3),
	append(Viz, Extr, Viz2),
	get_element(Q3, 0, FirstQ),
	bfs_main_rec(FirstQ, L, F, D, Q3, Viz2, NewParent, Sol).


bfs(Source, Dest, L, F, R):-
	get_list_len(L, Len),!,
	bfs_init_parent(Len, Parent),!,
	bfs_main_rec(Source, L, F, Dest, [Source], [Source], Parent, NewParent),!,
	bfs_reproduce_way(Dest, Source, NewParent, L, [], R).

/*END BFS-----------------------------------------*/

/*Generarea elementelor ---------------------------- */

/*Genereaza elemente diferite de pozitia curenta*/
get_individual_pos(_, _, _, 0, Acc, Acc).
get_individual_pos(X, Y, PossiblePos, Index, Acc1, Acc2):-
	get_list_len(PossiblePos, MaxLen),
	random_s(MaxLen, RandomX),
	get_element(PossiblePos, RandomX, E),
	not(list_contain(E, Acc1)),
	get_element(E, 0, X1),
	get_element(E, 1, Y1),
	(X \= X1; Y \= Y1),
	NextIndex is Index - 1,
	get_individual_pos(X, Y, PossiblePos, NextIndex, [E|Acc1], Acc2).
get_individual_pos(X, Y, PossiblePos, Index, Acc1, Acc2):-
	get_individual_pos(X, Y, PossiblePos, Index, Acc1, Acc2).

/*Genreaza un numar aleator de pozitii pornind din (X, Y)*/
gen_pos(X, Y, PossiblePos, R):-
	get_list_len(PossiblePos, Len),
	RealLen is Len-2,
	random_s(RealLen, RandomX),
	RealRandomX is RandomX+1,
	get_individual_pos(X, Y, PossiblePos, RealRandomX, [], R).

/*Calculeaza distanta Manhattan intre (X, Y), (SX, SY)*/
manhattan_dist(X, Y, [SX, SY], R):-
	f_abs(X, SX, R1), f_abs(Y, SY, R2), R is R1+R2.

/*Returneaza intensitatea semnalului relativ la pozitia pe care se afla personajul*/
get_pos_energy_signal(X, Y, [SX, SY, energy], S, R):-!,
	manhattan_dist(X, Y, [SX, SY], MDist), TmpA is S - MDist, modul_pos(TmpA, R).
get_pos_energy_signal(_, _, _, _, 0).


% get_energy_signal(+CurrentPosX, +CurrentPosY, +PlacesList,
% +EnergySignal, -SignalResult)
/*Returneaza intensitatea semnalului energiei relativ la pozitia pe care se afla personajul*/
get_energy_signal(_, _, [], _, 0).
get_energy_signal(X, Y, [H|PlaceList], S, Signal):-
	get_energy_signal(X, Y, PlaceList, S, SignalOnStack),
	get_pos_energy_signal(X, Y, H, S, R), f_max(R, SignalOnStack, Signal).

/*Returneaza pozitia initiala
*/
get_initial_pos([[X, Y, initial]|_], R):- R = [X, Y].
get_initial_pos([_|L], R):-get_initial_pos(L, R).

/*Returneaza pozitia portii
*/
get_gate_pos([[X, Y, gate]| _], R):- R = [X, Y].
get_gate_pos([_|L], R):-get_gate_pos(L, R).

/*Returneaza intensitatea semnalului portii relativ la pozitia pe care se afla personajul
*/
get_gate_signal(X, Y, PossiblePos, GS, Signal):-
	get_gate_pos(PossiblePos, Gate),
	get_element(Gate, 0, SX),
	get_element(Gate, 1, SY),
	get_pos_energy_signal(X, Y, [SX, SY, energy], GS, Signal).

/*Functia de comparare a cozii cu prioritati, de fapt euristica dupa care se
conduce cautarea
*/
comparator([X, Y], [X2, Y2], problema(PossiblePos, pachete(SE, _), poarta(SG, _))):-
	get_gate_signal(X, Y, PossiblePos, SG, RG),!,
	get_gate_signal(X2, Y2, PossiblePos, SG, RG2),!,
	get_energy_signal(X, Y, PossiblePos, SE, RE),!,
	get_energy_signal(X2, Y2, PossiblePos, SE, RE2),!,
	((RG < RG2);(RG>= RG2,RE >= RE2)).

/*Insereaza, in ordine un element in multimea Frontiera
*/
insert_to_frontier([X, Y|_], [], _, Sorted):-
	Sorted = [[X, Y]].
insert_to_frontier([X, Y|_], [H|L], Problema, Sorted):-
	not(comparator([X, Y], H, Problema)),
	insert_to_frontier([X, Y], L, Problema, SortedTemp),
	append([H], SortedTemp, Sorted).
insert_to_frontier([X, Y|_], L, _, Sorted):-
	append([[X, Y]], L, Sorted).

/*Sorteaza o lista folosind comparatorul
*/
sortList([], _, []).
sortList([H|L], Problema, Rez):-
	sortList(L, Problema, TempRez),
	insert_to_frontier(H, TempRez, Problema, Rez).

/*Returneaza elementul complet din problema dupa coordonate
*/
get_complete_elem([X, Y], [[X, Y, energy]|_], [X, Y, energy]).
get_complete_elem([X, Y], [[X, Y, gate]|_], [X, Y, gate]).
get_complete_elem([X, Y], [[X, Y]|_], [X, Y]).
get_complete_elem([X, Y], [_|L], R):-get_complete_elem([X, Y], L, R).


/*Returneaza o lista cu nodurile legate de nodul curent din frontiera*/
find_links(_, [], []).
find_links(E, [[P, S]|L], R):-find_links(E, L, RStack), find_elem(E, S), append(RStack, [P], R).
find_links(E, [_|L], R):-find_links(E, L, R).

/*Dintr-o lista de forma [X, [Y1, Y2, Y3...Yn]] genereaza o lista de
forma [[X, Y1], [X, Y2]..[X, Yn]]
*/
createEdges(_, [], []).
createEdges(S, [D|L], R):-createEdges(S, L, RStack), append([[S, D]], RStack, R).

/*Reuneste doua multimi de noduri
*/
mergeEdges(L, [], L).
mergeEdges(L1, [H|L2], R):-exist(L1, H), mergeEdges(L1, L2, R).
mergeEdges(L1, [H|L2], R):-mergeEdges([H|L1], L2, R).

/*Afla daca un element se gaseste in teritoriu
*/
existInTeritory(X, [[X|_]|_]).
existInTeritory(X, [_|L]):-existInTeritory(X, L).

/*Returneaza o lista cu lementele din lsita data ca argument
intersectata cu elementele din teritoriu
*/
intersectWithTeritory([], _, R, R).
intersectWithTeritory([H|L], Teritory, Acc1, Acc2):-
	existInTeritory(H, Teritory),
	append(Acc1, [H], AccTmp),
	intersectWithTeritory(L, Teritory, AccTmp, Acc2).
intersectWithTeritory([_|L], Teritory, Acc1, Acc2):-
	intersectWithTeritory(L, Teritory, Acc1, Acc2).

/*Insereaza un element in teritoriu, daca acesta nu exista
*/
insertNewInTeritory(_, [], []).
insertNewInTeritory([X, Y], [[Y, T]|L], R):-not(exist(T, X)),!,R = [[Y, [X|T]]|L].
insertNewInTeritory(E, [H|L], R):-
	insertNewInTeritory(E, L, RStack),!,
	append([H], RStack, R).

/*Atunci cand intr-un nod de frontiera se creeaza un nou portal,
	este posibil sa se creeze portale si spre pozitii din teritoriu de la care
	nu exista portal spre nodul curent, asadar nodul curent trebuie adaugat
	in lista de vecini al acelui nod*/
updateOldNodes([], Acc, Acc).
updateOldNodes([H|L], Teritory, Acc1):-
	insertNewInTeritory(H, Teritory, NewTeritory),
%	nl, write(H),nl, write(NewTeritory),
	updateOldNodes(L, NewTeritory, Acc1).

/* Updateaza vecinii nodului nou inclus in teritoriu*/
updateNeigh(E, L, Teritoriu, R):-
	find_links(E, Teritoriu, N),
	mergeEdges(L, N, R).

/*Updateaza teritoriul atunci cand un nou nod este adaugat
*/
updateTeritory(E, Expansion, Teritory, Frontier, WholeTeritory, NewFrontier):-
	intersectWithTeritory(Expansion, Teritory, [], TeritoryExpansion),!,
	createEdges(E, TeritoryExpansion, ExpPairs),!,
	updateOldNodes(ExpPairs, Teritory,  NewTeritory),!,

	updateNeigh(E, Expansion, Teritory, AllNeigh),!,
	append([[E, AllNeigh]], NewTeritory, WholeTeritory),!,

	deleteList(TeritoryExpansion, Expansion, FrontierExpansion),!,
	insertOnce(Frontier, FrontierExpansion, NewFrontier).

/*Elimina tag-ul dintr-o lista, e folosit pentru a elimina energia din problema
dupa ce a fost luata*/
remove_tag(_, [], L, L).
remove_tag([X, Y, _], [[X, Y, _]|L], Acc, R):-
	append(Acc, [[X, Y]], Acc2),
	remove_tag([X, Y], L, Acc2, R).
remove_tag(X, [H|L], Acc, R):-
	append(Acc, [H], Acc2),
	remove_tag(X, L, Acc2, R).

/*Elimina tag-urile dintr-o lista ce pot sau nu contine tag-uri
*/
remove_list_tag([], []).
remove_list_tag([[X, Y, _]|L], R):-remove_list_tag(L, RStack), append(RStack, [[X, Y]], R).
remove_list_tag([[X, Y]|L], R):-remove_list_tag(L, RStack), append(RStack, [[X, Y]], R).


write_neigh([], _, _, _):-nl.
write_neigh([[X, Y]|L], PossiblePos, SE, SG):-
	get_gate_signal(X, Y, PossiblePos, SG, GSignal),!,
	get_energy_signal(X, Y, PossiblePos, SE, ESignal),!,
	write('['), write(X), write(', '), write(Y), write(' | '), write(GSignal), write(' '), write(ESignal),write('], '),
	write_neigh(L, PossiblePos, SE, SG).

/*Genereaza poizitii fara tag-urile din problema
*/
gen_pos_no_tag(X, Y, PossiblePos, R):-!,
	gen_pos(X, Y, PossiblePos, ExpPos),!,
	remove_list_tag(ExpPos, R).

/*Aceasta regula este descrisa amanuntit in readme
*/
main_rec([X, Y, gate], MyEnergy, _, _,  problema(_, _, poarta(_, EG)), Cale, R):-
	EG =< MyEnergy,
	append(Cale, [[X, Y, gate]], R),
	write(MyEnergy),
	nl, write('Done, energy is enough').

main_rec([X, Y, gate], MyEnergy, _, _,  _, Cale, R):-
	append(Cale, [[X, Y, gate]], R),
	write(MyEnergy),
	nl, write('Done, the energy was not enough').


main_rec([X, Y], MyEnergy, Teritoriu, Frontiera, problema(PossiblePos,  pachete(SE, EE), poarta(SG, EG)), Cale, R):-
	gen_pos_no_tag(X, Y, PossiblePos, Expansion),
	updateTeritory([X, Y], Expansion, Teritoriu, Frontiera, UpdatedTeritory, UpdatedFrontier),!,
	sortList(UpdatedFrontier, problema(PossiblePos, pachete(SE, EE), poarta(SG, EG)), SortedFrontier),!,
	not(isEmpty(SortedFrontier)),!,
	pop_queue(SortedFrontier, NewFrontier, E),
	find_links(E, UpdatedTeritory, Parents),
	get_element(Parents, 0, P),
	bfs([X, Y], P, UpdatedTeritory, UpdatedFrontier, C),
	append(Cale, [[X, Y]], W),
	append(W, C, NewWay),
	get_complete_elem(E, PossiblePos, CompleteE),
	get_gate_signal(X, Y, PossiblePos, SG, GSignal),
	get_energy_signal(X, Y, PossiblePos, SE, ESignal),
	nl,write('-------------------------------'), nl,
	write('['), write(X), write(' '), write(Y), write(' | '), write(MyEnergy),write(' | '), write(GSignal), write(' '), write(ESignal),
	write(']:'),
	write_neigh(Expansion, PossiblePos, SE, SG),
	write('---------------------------------'), nl,
	nl, write('Energy: '),write(MyEnergy), nl,
	write('Frontiera: '), write(NewFrontier),nl,
	write('Teritoriu: '), write(UpdatedTeritory), nl,
	write('Next: '), write(CompleteE),nl,
	main_rec(CompleteE, MyEnergy, UpdatedTeritory, NewFrontier, problema(PossiblePos, pachete(SE, EE), poarta(SG, EG)), NewWay, R).


main_rec([X, Y, energy], MyEnergy, Teritoriu, Frontiera, problema(PossiblePos, pachete(SE, EE), poarta(SG, EG)), Cale, R):-
	NewEnergy is MyEnergy + EE,
	remove_tag([X, Y], PossiblePos, [], NewPossiblePos),
	gen_pos_no_tag(X, Y, PossiblePos, Expansion),
	updateTeritory([X, Y], Expansion, Teritoriu, Frontiera, UpdatedTeritory, UpdatedFrontier),!,
	sortList(UpdatedFrontier, problema(PossiblePos, pachete(SE, EE), poarta(SG, EG)), SortedFrontier),!,
	not(isEmpty(SortedFrontier)),!,
	pop_queue(SortedFrontier, NewFrontier, E),
	find_links(E, UpdatedTeritory, Parents),
	get_element(Parents, 0, P),
	bfs([X, Y], P, UpdatedTeritory, UpdatedFrontier, C),
	append(Cale, [[X, Y, energy]], W),
	append(W, C, NewWay),
	get_complete_elem(E, PossiblePos, CompleteE),
	get_gate_signal(X, Y, PossiblePos, SG, GSignal),
	get_energy_signal(X, Y, PossiblePos, SE, ESignal),
	nl,write('-------------------------------'), nl,
	write('['), write(X), write(' '), write(Y), write(' | '), write(MyEnergy),write(' | '), write(GSignal), write(' '), write(ESignal),
	write(']:'),
	write_neigh(Expansion, PossiblePos, SE, SG),
	write('---------------------------------'), nl,
	nl, write('Energy: '),write(MyEnergy), nl,
	write('Frontiera: '), write(NewFrontier),nl,
	write('Teritoriu: '), write(UpdatedTeritory), nl,
	write('Next: '), write(CompleteE),nl,
	main_rec(CompleteE, NewEnergy, UpdatedTeritory, NewFrontier, problema(NewPossiblePos, pachete(SE, EE), poarta(SG, EG)), NewWay, R).


go(problema(PossiblePos, pachete(SE, EE), poarta(SG, EG)), R):-
	get_initial_pos(PossiblePos, InitialPos),!,
	[X, Y] = InitialPos,!,
	remove_tag([X, Y, initial], PossiblePos, [], NewPossiblePos),write('3'), nl,!,
	main_rec([X, Y], 0, [], [],problema(NewPossiblePos, pachete(SE, EE), poarta(SG, EG)), [], R),
	nl, write(R).














