# Start simulation
vsim if_stage

# Windows
noview sim
noview objects
view transcript
view memory
view wave

# Add Waves
add wave -group "CPU Clock" -color "Grey60" -label "Clock" "sim:/if_stage/clk"
add wave -group "Inputs" -color "Magenta" -label "Jump Address" "sim:/if_stage/jump_address"
add wave -group "Inputs" -color "Magenta" -label "Branch Address" "sim:/if_stage/branch_address"
add wave -group "Inputs" -color "Magenta" -label "Fallback Address" "sim:/if_stage/fallback_address_in"
add wave -group "Operators" -color "Green" -label "Jump" "sim:/if_stage/jump"
add wave -group "Operators" -color "Green" -label "Branch" "sim:/if_stage/branch"
add wave -group "Operators" -color "Green" -label "Fallback" "sim:/if_stage/fallback"
add wave -group "Intermediaries" -color "Orange" -label "Branch Command" "sim:/if_stage/branch_command"
add wave -group "Intermediaries" -color "Orange" -label "Delayed Clock" "sim:/if_stage/delayed_clk"
add wave -group "Intermediaries" -color "Orange" -label "Check Jump" "sim:/if_stage/check_jump"
add wave -group "Intermediaries" -color "Orange" -label "Check Branch" "sim:/if_stage/check_branch"
add wave -group "Intermediaries" -color "Orange" -label "PC - D" "sim:/if_stage/d_pc"
add wave -group "Intermediaries" -color "Orange" -label "PC - Q" "sim:/if_stage/q_pc"
add wave -group "Outputs" -color "Cyan" -label "Predicted Address" "sim:/if_stage/predicted_address"
add wave -group "Outputs" -color "Cyan" -label "Fallback Address" "sim:/if_stage/fallback_address_out"
add wave -group "Outputs" -color "Cyan" -label "Instruction" "sim:/if_stage/instruction"

# Set memory
mem load -filltype value -fillradix hexadecimal -filldata {0} \
    "sim:/if_stage/branch_target_buffer/branch_table/table"
mem load -filltype value -fillradix hexadecimal -filldata {
    5F 22 9B 23  8B 84 BD 30  6E D9 64 CB  5B D5 75 A1
    F7 F9 65 B6  84 7C D9 E0  57 5F 51 F1  F3 B1 85 74
    D0 7F E4 AD  A4 F6 0B 60  53 F1 75 8E  72 66 18 8A
    31 CD 16 E1  94 B9 77 DA  78 4A 3A A5  0A D3 41 4A
    C1 BD 77 38  B5 01 BD 6C  94 0E 68 82  6D 4A D1 06
    E4 13 99 1B  20 7D B6 A1  73 41 D4 81  24 1A 0F FE
    FA 2A 30 F8  EF DC EE 46  2E FE CE 1B  37 8B 67 73
    4D AE 27 7B  7B 15 A6 20  34 37 A6 05  A2 56 DB 70
} "sim:/if_stage/instruction_memory/memory"

# Initialize clock
force -freeze -repeat 100ns "sim:/if_stage/clk" 0 0ns, 1 50ns

# Initialize program counter
force -freeze -cancel 10ns "sim:/if_stage/q_pc" 0 0ns

# Test Incrementing Program Counter
force -freeze "sim:/if_stage/jump" 0 0ns
force -freeze "sim:/if_stage/branch" 0 0ns
force -freeze "sim:/if_stage/fallback" 0 0ns
# Predicted address should be pc + 4
# Fallback address should be pc + 4
# Instruction should be instruction at pc

# Test Jump Command (jumping back)
# Set jump address
force -freeze "sim:/if_stage/jump_address" 32'h00000014 100ns
# Set jump to 1
force -freeze "sim:/if_stage/jump" 1 100ns
# Predicted address should be jump address
# Fallback Address should be pc + 4
# Instruction should be instrution at jump address

# Increment until pc address is at the address when jump was executed
# Predicted address should be jump address
# Fallback Address should be pc + 4
# Instruction should be instrution at pc

# Test Branch Command
# Predicted address should be branch address
# Fallback Address should be pc + 4
# Instruction should be instrution at pc

# Run
run 200ns
