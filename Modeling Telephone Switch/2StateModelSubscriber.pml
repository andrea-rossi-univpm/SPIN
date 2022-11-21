 /* 
    Two-State Model of Subscriber
    Interaction resctricted between a single subscriber with a single local switch. (Simplified abstract model)
    Information flows only from the subscriber to the switch in the form off off-hook, on-hook, and digit signals.
    ---- on-hook and off-hook are two states of a communication circuit. 
    ---- On subscriber telephones the states are produced by placing the handset onto or off the hookswitch. 
    (Switch is designed to be much faster than a human subscriber --> 
    Its assumed that the switch will always be ready to receive any signals form its subribers. )
*/

mtype = { offhook, digits, onhook };
/* CHAN -> declaring and initializing message passing channels 
Channels are used to transfer messages between active processes.
*/
chan tpc = [0] of { mtype };

active proctype subscriber()
{
    Idle: tpc!offhook;  /* IDLE: inactive */
    Busy:   if
                :: tcp!digits -> goto Busy
                :: tcp!onhook -> goto Idle
            fi
}


/* CONCLUSION : In this simple model, an outgoing call attempt of the subscriber may succeed or fail.
                This depends on network state and on state of other subscribers */
                