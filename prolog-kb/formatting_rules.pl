print_heading(X) :-
    nl,
    bold(X),
    nl.

bold(Text) :-
    write('\e[1m'),
    write(Text),
    write('\e[0m').
