# Start simulation
vsim cpu

# Windows
noview sim
noview objects
view transcript
view memory
view wave

# Add Waves
add wave -group "CPU Clock" -color "Grey60" -label "Clock" "sim:/cpu/clk"
# PC STAGE
add wave -group "PC Stage" -color "White" -label "PC" "sim:/cpu/PC_pc"
add wave -group "PC Stage" -color "White" -label "Predicted Address" "sim:/cpu/PC_predicted_address"
add wave -group "PC Stage" -color "White" -label "Fallback Address" "sim:/cpu/PC_fallback_address"
# IF STAGE
add wave -group "IF Stage" -color "Red" -label "Instruction" "sim:/cpu/IF_instruction"
add wave -group "IF Stage" -color "Red" -label "Predicted Address" "sim:/cpu/IF_predicted_address"
add wave -group "IF Stage" -color "Red" -label "Fallback Address" "sim:/cpu/IF_fallback_address"

# Clear instruction memory
mem load -filltype value -filldata {0} "sim:/cpu/if_stage_i/instruction_memory/memory"
# Set instruction memory
    # lw $t0 $zero 8
    # lw $t1 $zero 12
    # addi $s0 $zero 298
    # add $t2 $t0 $t1
    # addi $t3 $t0 13
    # slt $t4 $t3 $s0
    # beq $t4 $zero 32
    # j 16
    # sw $t4 $zero 16
mem load -filltype value -fillradix hexadecimal -filldata {
    8C 08 00 08
    8C 09 00 0C
    20 10 01 2A
    01 09 50 20
    21 0B 00 0D
    01 70 60 0A
    10 0C 00 20
    08 00 00 10
    AC 0C 00 10
} -startaddress 0 -endaddress 35 "sim:/cpu/if_stage_i/instruction_memory/memory"

# Start clock
force -freeze -repeat 100ns "sim:/cpu/clk" 0 0ns, 1 50ns

# Run
run 1500ns
