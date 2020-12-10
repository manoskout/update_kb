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
    add_to_kb.
    
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
    /* Διαγραφη από την βάση γνώσης 
    Πρέπει να λάβουμε υπόψην ότι έχουμε 2 επιπλέον "συνδεδεμένες" γνώσεις
    στην ΒΓ. Άρα πρέπει να πειράξουμε και αυτές τις πληροφορίες
    1) Διαγραφή του εργαζομένου, μέσω του ID
    2) Διαγραφή του ID απο την λίστα με τα ID των εργαζομένων
    3) Εισαγωγή των νέων δεδομένων στο αρχείο
    */
    write("Give the ID --> "),
    read(Id),nl,
    %  Βήμα 1 
    retract(ergazomenos(Id,_)), % βγάζουμε το κατηγόρημα με το συγκεκριμένο ονομα και επώνυμο
    %  Βήμα 2 (Γίνετε με δύο τρόπου)
        % α) subtract/3  
            % Info: https://www.swi-prolog.org/pldoc/doc_for?object=subtract/3
            % subtract([1,2,3,4],[1],R).     
            % ?-R=[2,3,4].
 %  id_ergazomenwn(L), % Παίρνουμε την Λιστα με τα ID
 %  subtract(L,[Id],NewList), % H νέα λίστα που παίρνουμε είναι χωρίς το ID   
        % β) selectchk/3 
            % Info: https://www.swi-prolog.org/pldoc/doc_for?object=selectchk/3
            % selectchk(2,[1,2,3,4],L).
            % L = [1, 3, 4].
  % id_ergazomenwn(L), % Παίρνουμε την Λιστα με τα ID
  % selectchk(Id,L,NewList),
        % γ) delete/3
            % Info: https://www.swi-prolog.org/pldoc/doc_for?object=delete/3
            % delete([1,2,3,4],1,R).
            % ?-R=[2,3,4].
    id_ergazomenwn(L), % Παίρνουμε την Λιστα με τα ID
    delete(L,Id,NewList), % H νέα λίστα που παίρνουμε είναι χωρίς το ID 
    
    % Βήμα 3
    retractall(id_ergazomenwn(_)), % διαγραφη της Λιστας με τα ID
    asserta(id_ergazomenwn(NewList)). % εισαγωγή της νεας Λιστσς με τα ID
    
add_to_kb:-
    /* Προσθήκη στην βαση γνωσης 
    Εδώ πρέπει να λάβουμε υπόψην ότι πρωτού εισάγουμε την νεα εγγραφή πρέπει 
    να ενημερώσουμε και το id_ergazomenwn/1
    Βήματα :
        1) Εισαγωγή των στοιχείων,
        2) προσθήκη του new ID στην λίστα  id_ergazomenwn       
    */
    % Βήμα 1
    write("Dwse ta stoixeia gia thn dimioyrgia eggrafhs"),nl,
    read(Info),
    id_ergazomenwn(IDS), % IDS = [....] Αποθηκεύουμε την λίστα στο IDS
    last(IDS,TeleutaioStoixeio), % Παίρνουμε το τελευταίο στοιχείο της Λίστας
    NewID is TeleutaioStoixeio +1, % Αυξάνουμε το ID κατα 1 για να το χρησιμοποιήσουμε στην νεα εγγραφή
    assertz(ergazomenos(NewID,Info)), % Εισάγουμε την νέα εγγραφή ΣΤΟ ΤΕΛΟΣ (εξού και το z) της γνώσης
    append(IDS,[NewID],NewListOfIDS), % "Κουμπόνουμε" το ID της νέας εγγραφής στην Λίστα
    retractall(id_ergazomenwn(_)), % Διαγράφουμε την γνώση του id_ergazomenwn 
    asserta(id_ergazomenwn(NewListOfIDS)). % Εισάγουμε την νέα γνώση id_ergazomenwn 
    



% Αποθηκευση στην βαση γνώσης 1ος τροπος
save_the_results:-
    /* Αποθήκευση αλλαγών */
    tell('kb_new.pl'), % φόρτωση αρχείου για εισαγωγή δεδομένων
    % max_id_ergazomenwn/1,id_ergazomenwn/1,ergazomenos/2.
    listing(id_ergazomenwn),
    listing(ergazomenos),
    told. % Τέλος του streaming αποθήκευση των δεδομένων

% Αποθήκευση στηνς βάση γνλωσης 2ος τροπος
% Υπενθήμυση ... το tell/1 γράφει στο αρχείο τα OUTPUTS που υπάρxουν αναμεσα με το told
save_the_resultsB:-
    tell('kb_new.pl'),
    write(":- dynamic id_ergazomenwn/1,ergazomenos/2."),nl,nl,
    clause(id_ergazomenwn(L),_), % Βρίσκουμε το L
    write(id_ergazomenwn(L)), write("."),nl,nl,
    % Για τους εργαζόμενους οπως καταλαβαίνουμε χρειαζόμαστε αναδρομή
    save_students(L),
    told.

save_students([]).
save_students([H|T]):-
    ergazomenos(H,L),
    write(ergazomenos(H,L)),write("."),nl,
    save_students(T).