# ECEC-412---Modern-Processor-Design

# Part 1 - Stack Impelemntation

`push - 'eba00004'`
`pop - 'efb00000'`

Test: 
`push 4 = [sub $sp, 4] + [sw 4, 0($sp)];`
`pop $s1 = [lw $s1, 0($sp)] + [add $sp, 4]`

