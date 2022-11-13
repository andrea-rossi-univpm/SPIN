byte
n = 0;
proctype P() {
    byte temp, i;
    for (i: 1..100) {
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