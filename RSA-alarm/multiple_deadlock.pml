// MODELLO Simile a quello reale: nella stanza di controllo delle infermiere c'è una lampadina per stanza.
// Esempio con 50 stanze
// il corretto funzionamento è applicato tramite l'implementazione di un vettore.
// ogni processo va a lavorare solo su un elemento del vettore ( che è la lampadina )

#define rooms 10
bool lampsOn[rooms]    //vettore delle lampadine
bool Alarms[rooms]    //vettore delle campanelle


// ## INLINE FUNCTIONS ##########################################################################
inline NotifyAlarm (room) {
    // d_step: instructions inside {} are executed as one indivisible statement
    d_step {
        printf("-----> L'Anziano della stanza [%d] sta suonando la campanella\n", room);
        Alarms[room] = true; 
        lampsOn[room] = true;
    }
}

inline HandleAlarm (room) {
    // d_step: instructions inside {} are executed as one indivisible statement
    d_step {
        printf("=====> Allarme della Stanza %d gestito!\n", room); 
        lampsOn[room] = false; 
    }
}

// ## END INLINE FUNCTIONS ##########################################################################


proctype Anziano(byte room) {
    printf("Processo Anziano della stanza [%d] - PID: [%d]\n",room, _pid); 
    do
    ::
        if 
            //risuonare l'allarme (campanella) non aggiunge effetto sulla campanella!
            :: Alarms[room] == true -> skip;
            :: else -> NotifyAlarm(room);
        fi
        
    od
}





proctype Infermiera() {
    printf("Processo Infermiera [%d]\n", _pid);
    byte counter = 1;
    do
    ::
        printf("**** Check Infermiera ****\n")
        for (counter: 0.. rooms){
            if 
                :: lampsOn[counter] == true -> HandleAlarm(counter);
            fi
        }
    od
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
    atomic {
        run Infermiera();
        run Anziano(1);
        run Anziano(2);
    }

}


// *** sequenzializzazione: spin -p -g simple.pml 

// *** per effettuare la verifica del modello:
// spin -a simple.pml
// gcc -w -o pan pan.c
// ./pan

// *** per la simulazione interattiva: spin -i simple.pml