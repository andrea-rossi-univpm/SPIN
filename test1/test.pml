byte n = 0;
proctype P() {
    byte temp, i;
    for (i: 1..20) {
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
    assert (n > 1) // per cercare il caso peggiore
}

/* With 100 iteration there is no enough memory to use depth searc.
   Instead can be used breadht first search (USING DBFS FLAG) (Standar queue used)
   
   git clean -xdf
   spin -a test.pml
   gcc -DBFS -o pan pan.c 
   gcc -w -DBFS -o pan pan.c 
   ./pan

   BREADTH SEARCH can consume more memory but is guaranteed to find the shortest path to an error
*/

/*
 -DSC -> stack cycling (arrange for the verifier to swap parts of the search stack to disk during a verification run)
*/

// gcc -w -o pan pan.c -> gcc compiler silence warning with -w!

// gcc -w -DBFS_PAR -o pan pan.c => multi thread bdfs  [ Multi-Core (using 7 cores) Breadth-First Search ]

// è verificato (anche con depth first) che n possa valere 0! (con 50 iterazioni)
//Depth=     412 States=  7.7e+07 Transitions= 1.14e+08 Memory=  3562.116 t=     60.9 R=   1e+06