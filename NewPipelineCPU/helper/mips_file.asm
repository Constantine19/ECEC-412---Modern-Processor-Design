lw $t0 $zero 8
lw $t1 $zero 12
addi $s0 $zero 298
add $t2 $t0 $t1
addi $t3 $t0 13
slt $t4 $t3 $s0
beq $t4 $zero 32
j 16
sw $t4 $zero 16
