# Start simulation
vsim control

# Windows
noview sim
noview objects
view transcript
view wave

# Add waves
add wave -color "Magenta" -label "Opcode" "sim:/control/opcode"
add wave -group "Outputs" -color "Cyan" -label "ALU Op" "sim:/control/aluop"
add wave -group "Outputs" -color "Cyan" -label "Reg Src" "sim:/control/regsrc"
add wave -group "Outputs" -color "Cyan" -label "Jump" "sim:/control/jump"
add wave -group "Outputs" -color "Cyan" -label "ALU Src" "sim:/control/alusrc"
add wave -group "Outputs" -color "Cyan" -label "Branch" "sim:/control/branch"
add wave -group "Outputs" -color "Cyan" -label "MemWrite" "sim:/control/memwrite"
add wave -group "Outputs" -color "Cyan" -label "MemRead" "sim:/control/memread"
add wave -group "Outputs" -color "Cyan" -label "Mem2Reg" "sim:/control/mem2reg"
add wave -group "Outputs" -color "Cyan" -label "RegWrite" "sim:/control/regwrite"
add wave -group "Outputs" -color "Cyan" -label "StackOp" "sim:/control/stackop"
add wave -group "Outputs" -color "Cyan" -label "StackPushPop" "sim:/control/stackpushpop"

# Add patterns
set time 0
for {set opcode 0} {$opcode < 63} {incr opcode} {
    force -freeze "sim:/control/opcode" $opcode $time
    set time [expr $time + 100]
}

# Run
run $time
