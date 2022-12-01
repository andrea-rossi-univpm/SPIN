// MAX INT: (2^31-1) => 2.147.483.647
// byte: (2^8-1) => 255
// short: (2^16-1) =>    32.767
byte n = 0;
proctype P() {
    byte temp, i;
    for (i: 1..10) {
        temp = n;
        n = temp + 1
    }
}

init {
    int counter;
    int accumulator = 0;

    printf("============================ START 1 Milion ========================== \n\n");
    for (counter: 1..1000000) { 
    if 
        :: counter % 25000 == 0 -> printf("Iterazion number: %d\n", counter);
        :: else -> skip;
    fi;   

    n = 0;  //resetting global variable for each try
    atomic {
        run P();
        run P();
    }

    (_nr_pr == 1); // forza init ad attendere gli altri due

    accumulator = accumulator +n;

    if 
        :: n < 10 -> printf("=============== Il valore è %d\n", n);
        :: else -> skip;
    fi;
    }

    //assert (n > 2) // per cercare il caso peggiore
    printf("\n\nCounter is: [%d], Accumulator is: [%d]\n", counter, accumulator);
    printf("\n\n ============================ END ============================ \n\n");

    printf("Average value: [%d]\n\n", accumulator/counter);
}
