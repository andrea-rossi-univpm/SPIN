// Simulazione RANDOM del paziente che suona la campanella (cioè accende l'allarme)
//d_step stands for DETERMINISTIC STEPS

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

proctype RandomAlarms(byte alarms)
{
    byte k = 0;
    int nr = 0;
    //byte generated[alarms];

    for(k: 1.. alarms) {
        again:
         // _picking a random value of byte size (2^(8-1)) equivalent unsigned char of C
        // byte would produce number between 0 and 255. Maximum allowed is room number!
            nr = 0;
            do
                :: nr++ // random increment 
                :: nr-- //or random decrement
                :: break //or stop 
            od;
        //if :: (nr > (rooms-2) || nr <= 0) -> printf("------ Numero generato %d fuori range.\n",nr); goto again
        //   :: else if
        //                :: ( k > 0 && nr == generated[k-1]) -> printf("-*-*-* Numero generato %d già estratto.\n",nr); goto again
        //                :: else -> generated[alarms] = nr;
        //            fi;
        //fi;

        printf(">>>>> Generato numero: %d\n", _pid, nr);

        if :: nr < rooms -> atomic { run Anziano(nr); } fi;
        
    }
}


init {
    
    byte counter;
    for (counter: 0.. rooms-1) {
        lampsOn[counter] = 0;
        Alarms[counter] = 0;
    }

    printf("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Situazione iniziale:\n\n")
    PrintSituation(); 
    printf("\n\n\n");

    //lancio i processi contemporaneamente
    atomic {
        run RandomAlarms(5);
        run Infermiera();
    }

    (_nr_pr == 1); // forza init ad attendere gli processi


    printf("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Situazione finale:\n\n")
    PrintSituation(); 
    printf("\n\n\n");

    //asserisco se alla fine delle verifiche dell'infermiera tutte le richieste siano state gestite
    for (counter: 0.. rooms-1) {
        assert( lampsOn[counter] == false && Alarms[counter] == false);
    }
}


// *** sequenzializzazione: spin -p -g simple.pml 

// *** per effettuare la verifica del modello:
// spin -a simple.pml
// gcc -w -o pan pan.c
// ./pan

// *** per la simulazione interattiva: spin -i simple.pml