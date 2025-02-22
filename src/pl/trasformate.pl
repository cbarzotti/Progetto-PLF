/* MAIN */
/* Il programma accetta in input una lista di numeri reali,
   calcolandone e stampandone i risultati:
     - la trasformata discreta del coseno (DCT);
     - relativa trasformata inversa (IDCT).
   
   Viene poi richiesta in input una lista di numeri complessi,
   calcolandone e stampandone i risultati:
     - la trasformata discreta di Fourier (DFT);
     - relativa trasformata inversa. */
main :-
  nl,
  write('Progetto della sessione autunnale del corso Programmazione Logica e Funzionale'), nl,
  write('Anno 2021/2022'), nl,
  write('Corso tenuto dal prof. Marco Bernardo'), nl,
  write('Progetto realizzato da: Barzotti Cristian e Kania Nicholas'), nl, nl, nl,

  acquire_real_list(RealList), nl,
  dct(RealList, C),
  write('DCT:'), nl,
  write(C), nl, nl,
  idct(C, DctOriginal),
  write('IDCT:'), nl,
  write(DctOriginal), nl, nl,nl,
  
  acquire_complex_list(ComplexList), nl,
  dft(ComplexList, X),
  write('DFT:'), nl,
  write(X), nl, nl,
  idft(X, DftOriginal),
  write('IDFT:'), nl,
  write(DftOriginal), nl.



/* DCT */
/* Funzione per il calcolo della DCT */
dct([], []).
dct([X | Y], C) :-  
  size([X | Y], S),
  generate_dct([X | Y], S, 0, C).
                    
/* Genera la trasformata */
generate_dct([], _, _, []).
generate_dct(L, S, K, C) :- 
  ((K == S) -> 
    C = [];
    K1 is K + 1,
    generate_dct(L, S, K1, C1),
    sum_terms_dct(L, S, K, 0, E),
    append([E], C1, C)).

/* Effettua il calcolo del k-esimo elemento della trasformata */
sum_terms_dct([], _, _, _, 0.0).
sum_terms_dct([H | T], S, K, N, C) :- 
  N1 is N + 1,
  sum_terms_dct(T, S, K, N1, C1),
  C is C1 + (H * 2 * cos(pi * (2 * N + 1) * K / (2 * S))).



/* IDCT */
/* Funzione per il calcolo della IDCT */
idct([], []).
idct([X | Y], C) :- 
  size([X | Y], S),
  generate_idct([X | Y], S, 0, C).

/* Genera la trasformata inversa (serie originale) */                    
generate_idct([], _, _, []).
generate_idct([H | T], S, N, C) :- 
  ((N == S) -> 
    C = [];
    N1 is N + 1,
    generate_idct([H | T], S, N1, C1),
    sum_terms_idct(T, S, N, 1, E),
    X is (H + E) / (2 * S),
    append([X], C1, C)).

/* Effettua il calcolo della sommatoria per k-esimo elemento della trasformata inversa */
sum_terms_idct([], _, _, _, 0.0).
sum_terms_idct([H | T], S, N, K, C) :- 
  K1 is K + 1,
  sum_terms_idct(T, S, N, K1, C1),
  C is C1 + (H * 2 * cos(pi * (2 * N + 1) * K / (2 * S))).



/* DFT */
/* Funzione per il calcolo della DFT */
dft([], []).
dft([X | Y], C) :- 
  size([X | Y], S),
  generate_dft([X | Y], S, 0, C).

/* Genera la trasformata */                 
generate_dft([], _, _, []).
generate_dft(L, S, K, C) :- 
  ((K == S) -> 
    C = [];
    K1 is K + 1,
    generate_dft(L, S, K1, C1),
    sum_terms_dft(L, S, K, 0, E),
    append([E], C1, C)).

/* Effettua il calcolo del k-esimo elemento della trasformata */
sum_terms_dft([], _, _, _, (0,0)).
sum_terms_dft([H | T], S, K, N, C) :- 
  N1 is N + 1,
  THETA is (-((2 * pi) / S) * N * K),
  sum_terms_dft(T, S, K, N1, C1),
  complex_prod(H, (cos(THETA),sin(THETA)), P),
  complex_sum(P, C1, C).



/* IDFT */
/* Funzione per il calcolo della IDFT */
idft([], []).
idft([X | Y], C) :- 
  size([X | Y], S),
  generate_idft([X | Y], S, 0, C).            

/* Genera la trasformata inversa (serie originale) */
generate_idft([], _, _, []).
generate_idft(L, S, N, C) :-
  ((N == S) -> C = [];
  N1 is N + 1,
  generate_idft(L, S, N1, C1),
  sum_terms_idft(L, S, N, 0, E),
  complex_div_real(E, S, P),
  append([P], C1, C)).

/* Calcolo della sommatoria per il k-esimo elemento */
sum_terms_idft([], _, _, _, (0,0)).
sum_terms_idft([H | T], S, N, K, C) :- 
  K1 is K + 1,
  THETA is (((2 * pi) / S) * N * K),
  sum_terms_idft(T, S, N, K1, C1),
  complex_prod(H, (cos(THETA),sin(THETA)), P),
  complex_sum(P, C1, C).



/* FUNZIONI AUSILIARIE */
/* Funzione per calcolare il numero di elementi in una lista */
size([], 0).
size([_ | Y], S) :-
  size(Y, S1),
  S is S1 + 1.

/* Funzione che definisce il prodotto fra numeri complessi */
complex_prod((ZR, ZI), (WR, WI), (R,I)) :-  
  R is (ZR * WR - ZI * WI),
  I is (ZR * WI + ZI * WR).

/* Funzione che definisce la somma fra numeri complessi */
complex_sum((ZR, ZI), (WR, WI), (R,I)) :- 
  R is ZR + WR, 
  I is ZI + WI.

/* Funzione che definisce la divisione fra un numero complesso ed un numero reale */
complex_div_real((ZR, ZI), N, (R, I)) :- 
  R is ZR / N, 
  I is ZI / N.

/* Acquisisce una lista di numeri reali da tastiera.
   La funzione non termina fino a quando non verrà inserita una lista valida. */
acquire_real_list(List) :-
  repeat,
  write('Inserisci una lista di numeri reali nel formato:'), nl, nl,
  write('\t[<numero>, ...].'), nl, nl,
  write('Per esempio: [1, 0.5, -3].'), nl,
  catch(read(List), Error, true),
  ((check_real_list(List), var(Error)) -> 
    !;
    nl, write('Errore.'), nl, fail).

/* Acquisisce una lista di numeri complessi da tastiera.
   La funzione non termina fino a quando non verrà inserita una lista valida. */
acquire_complex_list(List) :-
  repeat,
  write('Inserire una lista di numeri complessi nel formato:'), nl, nl,
  write('\t[(<parte reale>, <parte immaginaria>), ...].'), nl, nl,
  write('Per esempio: [(1,2), (0.5,-3), (0,0)].'), nl,
  catch(read(List), Error, true),
  ((check_complex_list(List), var(Error)) -> 
    !; 
    nl, write('Errore.'), nl, fail).

/* Controlla che una lista sia composta solo da numeri reali */
check_real_list([]).
check_real_list([A | L]) :- 
  ((number(A)) -> 
    check_real_list(L); 
    fail).

/* Controlla che una lista sia composta solo tuple rappresentanti numeri complessi */
check_complex_list([]).
check_complex_list([(A, B) | L]) :- 
  ((number(A), number(B)) -> 
    check_complex_list(L); 
    fail).