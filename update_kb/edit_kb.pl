:-consult('kb.pl').  % ανάγνωση της γνώσης


choices:-
    /*
    Είσοδος επιλογών
    */
    format('Dwse apo 1 ews 2 ~n 1) gia eisagwgh ~n 2) gia diagrafh~n Otidipote allo gia eksodo ~n -->'),
    read(X),
    ch(X),
    save_the_results,
    choices.

ch(1):-
    /* Επιλογή 1 - Εισαγωγή εργαζομένου*/
    add_from_kb.

ch(2):-
    /* Επιλογή 2 - Διαγραφή εργαζομένου*/
    delete_from_kb.

ch(_):-
    abort. % έξοδος απο τις επιλογές

%  Εναλλακτικά 

% ch(X):-
%     (
%         (
%             (
%                 X=:=1,
%                 add_from_kb
%             );
%             (
%                 X=:=2,
%                 delete_from_kb
%             )
%         ),
%         save_the_results

%     );
%     abort.



delete_from_kb:-
    /* Διαγραφη από την βάση γνώσης */
    write("Attribute 1 --> "),
    read(AttrA),nl,
    write("Attribute 2 --> "),
    read(AttrB),nl,
    retract(test_kb(AttrA,AttrB,_)). % βγάζουμε το κατηγόρημα με το συγκεκριμένο ονομα και επώνυμο

add_from_kb:-
    /* Προσθήκη στην βαση γνωσης */
    write("Attribute 1 --> "),
    read(AttrA),nl,
    write("Attribute 2 --> "),
    read(AttrB),nl,
    write("Attribute 3 --> "),
    read(AttrC),nl,
    assertz(test_kb(AttrA,AttrB,AttrC)). % Χρηση της assertz (εισάγη σαν τελευταία γνώση)

save_the_results:-
    /* Αποθήκευση αλλαγών */
    tell('kb.pl'), % φόρτωση αρχείου για εισαγωγή δεδομένων
    listing(test_kb), % επιστρέφει την γνώση που έχει σχετικά με το κατηγόρημα που του δίνουμε
    told. % Τέλος του streaming αποθήκευση των δεδομένων
