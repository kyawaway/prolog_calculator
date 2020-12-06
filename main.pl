parse(A, P) :- tokens(A, [], Q), add(Q, [], P).
add(A, C, P) :- multiply(A, B, Q), (add_options(B, C, Q, P); B = C, P = Q).
add_options(A, C, P, R) :- add_option(A, B, P, Q), (add_options(B, C, Q, R); B = C, Q = R).
add_option([0'+ | A], B, P, add(P, Q)) :- multiply(A, B, Q).
add_option([0'- | A], B, P, subtract(P, Q)) :- multiply(A, B, Q).
multiply(A, C, P) :- primary(A, B, Q), (multiply_options(B, C, Q, P); B = C, P = Q).
multiply_options(A, C, P, R) :- multiply_option(A, B, P, Q), (multiply_options(B, C, Q, R); B = C, Q = R).
multiply_option([0'* | A], B, P, multiply(P, Q)) :- primary(A, B, Q).
multiply_option([0'/ | A], B, P, divide(P, Q)) :- primary(A, B, Q).
primary([0'( | A], B, parenthesis(P)) :- add(A, [0') | B], P).
primary([integer(P) | A], A, integer(P)).
tokens(A, C, P) :- token(A, B, P, Q), (tokens(B, C, Q); B = C, Q = []).
token([A | B], B, P, P) :- member(A, [0' , 0'b, 0'f, 0'n, 0'r, 0't]).
token([A | B], B, [A | P], P) :- member(A, [0'+, 0'-, 0'*, 0'/, 0'(, 0')]).
token(A, B, [integer(Q) | P], P) :- integer(A, B, Q, _).
integer([A | B], C, S, R * 10) :- P is A - 0'0, P >= 0, P =< 9, (integer(B, C, Q, R), S is P * R + Q; B = C, S = P, R = 1).