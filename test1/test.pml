byte
n = 0;
proctype P() {
    byte temp, i;
    for (i: 1..10) {
        temp = n;
        n = temp + 1
    }
}

init {
    atomic {
        run P();
        run P();
    }

    (_nr_pr == 1); // forza init ad attendere gli altri due

    printf("Il valore è %d\n", n);
    assert (n > 2) // per cercare il caso peggiore
}

/* With 100 iteration there is no enough memory to use depth searc.
   Instead can be used breadht first search (USING DBFS FLAG) (Standar queue used)
   
   git clean -xdf
   spin -a test.pml
   gcc -DBFS -o pan pan.c 
   ./pan

   BREADTH SEARCH can consume more memory but is guaranteed to find the shortest path to an error
*/

/*
 -DSC -> stack cycling (arrange for the verifier to swap parts of the search stack to disk during a verification run)
*/