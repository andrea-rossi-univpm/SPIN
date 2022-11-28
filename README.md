# SPIN

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
