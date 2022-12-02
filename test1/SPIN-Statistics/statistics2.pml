// MAX INT: (2^31-1) => 2.147.483.647
// byte: (2^8-1) => 255
// short: (2^16-1) =>    32.767

#define threshold 10

byte n = 0;
proctype P() {
    byte temp, i;
    for (i: 1..10) {
        temp = n;
        n = temp + 1
    }
}

init {
    int repetition[40]; //numero delle occorrenze trovate per ogni numero possibile da 0 a 41
    int counter;
    int accumulator = 0;    // accumulatore per n

    for(counter: 1..40){
        repetition[counter] = 0;
    }

    printf("============================ START 1 Milion ========================== \n\n");
    for (counter: 1..1000000) { 

        if 
            :: counter % 100000 == 0 -> printf("Iterazion number: %d\n", counter);
            :: else -> skip;
        fi;   

        n = 0;  //resetting global variable for each try
        atomic {
            run P();
            run P();
        }

        (_nr_pr == 1); // forza init ad attendere gli altri due

        repetition[n]++;
        accumulator = accumulator +n;

        if 
            :: n < threshold -> printf("=============== Found n less than threshold => %d\n", n);
            :: else -> skip;
        fi;
    }

    //assert (n > 2) // per cercare il caso peggiore
    printf("\n\nCounter is: [%d], Accumulator is: [%d]\n", counter, accumulator);
    printf("\n\n ============================ END ============================ \n\n");

    printf("Average value: [%d]\n\n", accumulator/counter);

    for(counter: 1..40){
        printf("n=[%d] found [%d] times.\n",counter, repetition[counter])
    }

    int test = 0;
    for(counter: 1..40){
        test = test + repetition[counter];
    }

    printf("Sum of repetition [%d] equal to accumulator [%d]", test, accumulator);
}
