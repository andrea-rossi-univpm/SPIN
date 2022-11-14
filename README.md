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
