# ECEC-412---Modern-Processor-Design

# Part 1 - Stack Impelemntation

My initial idea was to create a micro-architecture block with the logic that takes two instructions as an input and outputs:

`push 4 = [sub $sp, 4] + [sw 4, 0($sp)];`
`pop $s1 = [lw $s1, 0($sp)] + [add $sp, 4]`

Since it is mentioned in the description to treat `push` and `pop` as an `i-type` instructions, I assigned my own OPCODE for those instructions:

`push - '110010' (50 decimal)`
`pop - '110011' (51 decimal)`

At the end I got very confused with conenctions in the CPU2 files and did not understand where to connect what. 