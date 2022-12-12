// MODELLO SEMPLIFICATO dell'allarme nelle RSA. L'anziano preme il bottone di allarme e si accende la lampadina (una sola!)
// stanza, allarme, anziano sono 1:1 (In ogni stanza c'è un allarme e un anziano)
// se l'allarme suona la lampadina nella stanza delle infermiere si accende.

// è un'implementazione di MUTUA ESCLUSIONE tra allarme (campanella) e lampadina 8i

// esempio semplificato con 2 soli anziani (2 allarmi e 1 lampadina)

bool lampOn = false;    //variabile globale che indica se la lampadina è accesa o meno (assistenza richiesta da parte di un anziano)
byte critica = 0;

bool AllarmeAnzianoStanza1 = false;
bool AllarmeAnzianoStanza2 = false;

proctype AnzianoStanza1() {
    printf("Processo Anziano 1 - PID: [%d]\n", _pid); 
    do
    ::
        AllarmeAnzianoStanza1 = true;
        critica++;
        printf("Sezione Critica Anziano 1\n");
        assert(critica <=1);
        lampOn = true;
        critica--;
    od
}

proctype AnzianoStanza2() {
    printf("Processo Anziano 2 - PID: [%d]\n", _pid); 
    do
    ::
        AllarmeAnzianoStanza2 = true;
        critica++;
        printf("Sezione Critica Anziano 2\n");
        assert(critica <=1);
        lampOn = true;
        critica--;
    od
}

proctype Infermiera() {
    printf("Processo Infermiera [%d]\n", _pid);
    do
    ::
        printf("**** Check Infermiera ****\n")
        if 
            :: lampOn == false -> printf("\n\nNessun allarme attivo\n\n"); skip;
            :: lampOn == true -> lampOn = false; printf("===== Lampadina gestita dall'infermiera\n");
                if 
                    :: AllarmeAnzianoStanza1 == true -> AllarmeAnzianoStanza1 = false; printf("L'allarme è stato generato dalla Stanza 1\n"); lampOn = false;
                    :: AllarmeAnzianoStanza2 == true -> AllarmeAnzianoStanza2 = false; printf("L'allarme è stato generato dalla Stanza 2\n"); lampOn = false;
                fi
        fi
    od
}

init {
    lampOn = 0;

    //lancio i processi contemporaneamente
    //atomic -> fragment of code that is to be executed indivisibly. Non interleaved by other process.
    atomic {
        run Infermiera();
        run AnzianoStanza1();
        run AnzianoStanza2();
    }

}

// NB: spin simple.pml -> SIMULATION MODE
//     spin -a simple.pml -> VERIFICATION MODE



// *** sequenzializzazione: spin -p -g simple.pml 

// *** per effettuare la verifica del modello:
// spin -a simple.pml
// gcc -w -o pan pan.c
// ./pan

// *** per la simulazione interattiva: spin -i simple.pml