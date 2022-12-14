// MAX INT: (2^31-1) => 2.147.483.647
// byte: (2^8-1) => 255
// short: (2^16-1) =>    32.767

#define threshold 10
#define iterations 20
#define tests 500000

byte n = 0;
proctype P() {
    byte temp, i;
    for (i: 1.. iterations) {
        temp = n;
        n = temp + 1
    }
}

init {
    int repetition[(iterations*2)+1]; //numero delle occorrenze trovate per ogni numero possibile da 0 a 20 (dimensione 21)
    int counter;
    int accumulator = 0;    // accumulatore per n

    for(counter: 0.. iterations*2){
        repetition[counter] = 0;
    }

    printf("============================ START with %d Tests ========================== \n\n", tests);
    for (counter: 1.. tests) { 

        if 
            :: counter % 50000 == 0 -> printf("Iteration number: %d\n", counter);
            :: else -> skip;
        fi;   

        n = 0;  //resetting global variable for each try
        atomic {
            run P();
            run P();
        }

        (_nr_pr == 1); // forza init ad attendere gli altri due

        repetition[n] = repetition[n] + 1;
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

    for(counter: 0.. iterations*2){
        printf("n=[%d] found [%d] times.\n",counter, repetition[counter]);
    }

    int test = 0;
    for(counter: 0.. iterations*2){
        test = test + (repetition[counter] * counter);
    }

    printf("\n\nSum of repetition [%d] equal to accumulator [%d]\n\n", test, accumulator);
}

//spin statistics2.pml