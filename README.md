# SPIN
## SPIN per VERIFICHE STATISTICHE

**** Premessa: in SPIN vengono simulati i processi, è un simulatore discreto. 
**** Tutte le grandezze in gioco devono essere discretizzate: si lavori per step, infatti è un automa a stati finiti.
**** Quindi non c'è bisogno di avere un float nella simulazione di processi discreti. (Imposibilità di calcolare la percentuale)
**** In SPIN modalità simulatore non si possono avere. (spin test.pml)
**** In SPIN modalità verificatore si possono avere (spin -a test.pml) utilizzando c_code utilizzando embedded C code.
****            --> c_code { 5/9 }    (pagina 222 del manuale di Holzmann)

statistics1.pml => valor medio di n
statistics2.pml => valor medio di n + numero di riperizioni dei valori estratti
statistics3.pml => loop infinito che da in output i valori minori della soglia
statistics_final.pml => data una certa soglia, si looppa finchè non viene raggiunto uno stato (valore di n) inferiore della soglia definita.

NB: Il valore minimo possibile che SPIN trova è 2. ( I due programmi vanno nella CPU almeno una volta)

## RSA

simple.pml => implementa il concetto della mutua esclusione, che non viene rispettata. 
              (Un paziente suona la campanella mentre già è stata suonata da un altro)
              => Con SPIN modalità verificatore viene fallita l'asserzione: failed assertion: assert((critica<=1))
              => evincendo il problema di mutua esclusione => considerando il circuito come senza memoria, 
                                                              suonando una campanella con singolo allarme lato infermiere già attivo, viene perso!


multiple.pml => miglioramento del modello tramite il vettore delle campanelle e il vettore degli allarmi. 
                C'è una campanella per stanza per generare un'allarme e una lampadina per stanza nella stanza degli infermieri.
                Ogni processo va a lavorare solo su un elemento del vettore ( che è la campanella ) ciclicamente.
                In questo caso l'infermiera (una sola) controlla sequenzialmente gli allarmi attivi e li gestisce in modo sequenziale.

                ==> Con SPIN in modalità simulatore si evince che il sistema funziona.
                

multiple_random.pml => stesso pattern del precedente ma gli anziani che generano un allarme sono random.
                       L'infermiera fa 5 verifiche.
                    
multiple_random2.pml => uguale al precedente ma l'infermiera fa infinite verifiche.

multiple_deadlock.pml => Variazione che va in deadlock: 
                         --> risuonare l'allarme (campanella) non aggiunge effetto sulla campanella
                         --> inolrte l'infermiera si aspetta sempre un allarme attivo.

NB: La funzione random  che restituisca un certo range non è possibile farla (a meno che di una divisione per 10 senza resto) perchè non è possibile mischiare determinismo e non determinismo.


# UTILS
## active [2] proctype run() { ... }

### every process has unique PID with 'active' keyword

## -t flag disable printf indent

## SPIN Output:

### every tab for each PID (PID used to tabulate output)

## typedef present

### multidimensional array: array { byte el[4] }; Array a[4]; [i][j]

## Message Channel

### ? is used for send operations (! to receive)

## In SPIN while(a!=b) can be written with (a == b) since SPIN is blocked until a is not equal to be

## SPIN can instantiate maximum 255 process

## --c; ++c; has no translate from C to SPIN (Promela).

## Ternary operator exists but to differentiate with send operation on message channel -> is used.

### Ternary: (expression -> function1 : function2)

## Atomic { ... } If the first instruction starts, others can't be interrupted by interleaving.

## d_STEP { ... } Set of instruction not divisible (goto can't be used)

## Inline fucnctions better than macro in PROMELA for debugging purpose

### In case of errors macro won't report the correct line, instead inline functions does.

## SCANF does not exist

### Altough STDIN can be used.

# Safety

## Safety is a set of properties that system may not violate.

# Liveness

## Liveness is a set of properties that system must satisfy.

# Predefined variables

## \_

## np\_

### np\_ is a flag (boolean) that indicates if system is in a progress or not progress state

## \_pid (process unique identifier)

## \_last (sort of instance number of process)

### Both np\_ and \_last are used on extraordinary situations like 'trace assertion' or 'never claim'

# Temporal Logic

## Both casual and temporal relations of properties.

## MTYPE

### mtype is used for defining symbolic names of numeric constants.

### mtype = { ack, nak, error, next, accept } is equivalent to:

### #define ack 5

### #define nak 4

### #define error 3

### #define next 2

### #define accept 1

### Symbols are numbered in reverse order! The lowest one is not zero but starts with one!

### these define in promela are stored into unsigned char C equivalent type.

## Proctype : for declaring new process behavior

## progress : label-name prefix for specifyng liveness properties.

## provided : for setting a global constraint on process execution.

## rand : for random number generation

### There is a pseudo random generator to resolve all cases of non-determinism.

active proctype randnr()
{
byte nr; /_picking a random value of byte size (2^(8-1)) equivalent unsigned char of C_/
do
:: nr++ /_ random increment _/
:: nr-- /_ or random decrement _/
:: break /_ or stop _/
do;
printf("nr: %d\n"); /\* number between 0 and 255
}

#### for this model spin verifier would generate at least 256 distinct reachable states for this model

#### Note: its also possible call rand() C Library using embedded C code. This can cause irreproducibile behavior and SPIN! (spin intercept the calls and re-define it to use depth-first-search.)
