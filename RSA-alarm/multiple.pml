// MODELLO Simile a quello reale: nella stanza di controllo delle infermiere c'è una lampadina per stanza.
// Esempio con 50 stanze
// il corretto funzionamento è applicato tramite l'implementazione di un vettore.
// ogni processo va a lavorare solo su un elemento del vettore ( che è la lampadina )

#define rooms 10
bool lampsOn[rooms]    //vettore delle lampadine
bool Alarms[rooms]    //vettore delle campanelle


// ## INLINE FUNCTIONS ##########################################################################

// Ternario: Dato che ? è usato per la inviare messaggi (! per riceverli), la sintassi è:
//            expression -> func1 : func2

inline PrintSituation(){
    printf("************* Allarmi attivi:\n");
    byte printIndex = 0;
    for (printIndex:0.. rooms-1) {
        printf("Stanza %d: %c\n", printIndex+1, (Alarms[printIndex] == false -> '-' : '+'));
    }

    printf("\n\n************* Campanelle accese:\n")
    for (printIndex:0.. rooms-1) {
         printf("Campanella stanza %d: %c\n", printIndex+1, (lampsOn[printIndex] == false -> '-' : '+')); 
    }

    printf("\n*************\n")
}

inline NotifyAlarm (room) {
    // d_step: instructions inside {} are executed as one indivisible statement
    if
     :: Alarms[room] == true ->
        d_step {
            printf("-----> L'Anziano della stanza [%d] sta suonando la campanella\n", room);
            Alarms[room] = true; 
            lampsOn[room] = true;
        }
     :: else ->  printf("Campanella risuonata [Stanza %d]\n", room); skip;
    fi
}

inline HandleAlarm (room) {
    // d_step: instructions inside {} are executed as one indivisible statement
    d_step {
        PrintSituation();
        printf("=====> Allarme della Stanza %d gestito dall'infermiera!\n", room); 
        lampsOn[room] = false; 
        Alarms[room] = false; 
    }
}



// ## END INLINE FUNCTIONS ##########################################################################


proctype Anziano(byte room) {
    printf("Processo Anziano della stanza [%d] - PID: [%d]\n",room, _pid); 
    Alarms[room] = true;
    NotifyAlarm(room);
    (Alarms[room] == false) // wait
}

proctype Infermiera() {
    printf("Processo Infermiera [%d]\n", _pid);

    byte i = 0, y = 0;
    for (i:0.. 5) { // L'infermiera fa 5 verifiche
        printf("**** Check Infermiera ****\n")
        for (y: 0.. rooms-1) {
            if 
                :: lampsOn[y] == true -> HandleAlarm(y);
                :: lampsOn[y] == false -> skip; 
                else -> skip;
            fi
        }
    }
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
    atomic {
        run Anziano(2);
        run Anziano(3);
        run Infermiera();
        run Anziano(1);
        run Anziano(2);
        run Anziano(3);
        run Anziano(1);
    }
}


// *** sequenzializzazione: spin -p -g simple.pml 

// *** per effettuare la verifica del modello:
// spin -a simple.pml
// gcc -w -o pan pan.c
// ./pan

// *** per la simulazione interattiva: spin -i simple.pml