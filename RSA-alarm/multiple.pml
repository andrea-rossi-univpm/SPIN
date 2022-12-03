// MODELLO Simile a quello reale: nella stanza di controllo delle infermiere c'è una lampadina per stanza.
// Esempio con 50 stanze
// il corretto funzionamento è applicato tramite l'implementazione di un vettore.
// ogni processo va a lavorare solo su un elemento del vettore ( che è la lampadina )

#define rooms 50
bool lampsOn[rooms]    //vettore delle lampadine
bool Alarms[rooms]    //vettore delle campanelle

proctype Anziano(byte room) {
    printf("Processo Anziano della stanza [%d] - PID: [%d]\n",room, _pid); 
    do
    ::
        printf("Anziano della stanza [%d] sta suonando la campanella");
        Alarms[room] = true
        lampsOn[room] = true
    od
}

proctype Infermiera() {
    printf("Processo Infermiera [%d]\n", _pid);
    byte counter = 1;
    //do
    //::
    //for counter.. rooms
    //    printf("**** Check Infermiera ****\n")
    //    if 
    //        :: lampOn == false -> printf("\n\nNessun allarme attivo\n\n"); skip;
    //        :: lampOn == true -> lampOn = false; printf("===== Lampadina gestita dall'infermiera\n");
    //            if 
    //                :: AllarmeAnzianoStanza1 == true -> AllarmeAnzianoStanza1 = false; printf("L'allarme è stato generato dalla Stanza 1\n"); lampOn = false;
    //                :: AllarmeAnzianoStanza2 == true -> AllarmeAnzianoStanza2 = false; printf("L'allarme è stato generato dalla Stanza 2\n"); lampOn = false;
    //            fi
    //    fi
    //od
}

// Ternario: Dato che ? è usato per la inviare messaggi (! per riceverli), la sintassi è:
//            expression -> func1 : func2

inline PrintSituation(){
    printf("************* Allarmi stanze:\n");

    for (counter:0.. rooms-1) {
        printf("Stanza %d: %c", counter+1, (Alarms[counter] == false -> '-' : '+'));
        if 
            :: counter % 4 == 0 -> printf("\n");
            :: else printf("\t");
        fi
    }


    printf("\n\n************* Campanelle delle stanze:\n")
    for (counter:0.. rooms-1) {
        printf("Campanella stanza %d: %c", counter+1, (lampsOn[counter] == false -> '-' : '+'));
        if 
            :: counter % 3 == 0 -> printf("\n");
            :: else printf("\t");
        fi
    }

    printf("\n*************\n")
}

init {
    byte counter;

    for (counter: 0.. rooms-1) {
        lampsOn[counter] = 0;
        Alarms[counter] = 0;
    }

    

    printf("Situazione iniziale:\n\n")

    PrintSituation();

    

    //lancio i processi contemporaneamente
    //atomic {
    //    run Infermiera();
    //    run AnzianoStanza1();
    //    run AnzianoStanza2();
    //}

}


// *** sequenzializzazione: spin -p -g simple.pml 

// *** per effettuare la verifica del modello:
// spin -a simple.pml
// gcc -w -o pan pan.c
// ./pan

// *** per la simulazione interattiva: spin -i simple.pml