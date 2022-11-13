/* PATHFINDER BUGGED */
/* spin -a pathfinder.pml */
/* gcc -o pan pan.c */

mtype = { free, busy, idle, waiting, running };

mtype H_state = idle;
mtype L_state = idle;
mtype mutex = free;

active proctype high_priority()
{
    end:  
        do
            :: H_state = waiting;
            atomic{ mutex == free -> mutex = busy };
            H_state = running;

            /*produce data*/
            atomic{ H_state = idle; mutex = free }
        od
}

active proctype low_priority() provided(H_state == idle)
{
    end:  
    do
      ::L_state = waiting;
      atomic{ mutex == free -> mutex = busy};
      L_state = running;

      /* consumer data */
      atomic{ L_state = idle; mutex = free}
    od
}