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
add wave -group "Inputs" -color "Red" -label "Program Counter" "sim:/if_stage/pc"
add wave -group "Inputs" -color "Red" -label "Predicted Address" "sim:/if_stage/predicted_address_in"
add wave -group "Inputs" -color "Red" -label "Fallback Address" "sim:/if_stage/fallback_address_in"
add wave -group "Inputs" -color "Red" -label "Branch" "sim:/if_stage/branch"
add wave -group "Outputs" -color "Cyan" -label "Predicted Address" "sim:/if_stage/predicted_address_out"
add wave -group "Outputs" -color "Cyan" -label "Fallback Address" "sim:/if_stage/fallback_address_out"
add wave -group "Outputs" -color "Cyan" -label "Instruction" "sim:/if_stage/instruction"

# Set memory
mem load -filltype value -fillradix hexadecimal -filldata {
    5F 22 9B 23  8B 84 BD 30  6E D9 64 CB  5B D5 75 A1
    F7 F9 65 B6  84 7C D9 E0  57 5F 51 F1  F3 B1 85 74
    D0 7F E4 AD  A4 F6 0B 60  53 F1 75 8E  72 66 18 8A
    31 CD 16 E1  94 B9 77 DA  78 4A 3A A5  0A D3 41 4A
    C1 BD 77 38  B5 01 BD 6C  94 0E 68 82  6D 4A D1 06
    E4 13 99 1B  20 7D B6 A1  73 41 D4 81  24 1A 0F FE
    FA 2A 30 F8  EF DC EE 46  2E FE CE 1B  37 8B 67 73
    4D AE 27 7B  7B 15 A6 20  34 37 A6 05  A2 56 DB 70
} -startaddress 0 -endaddress 128 "sim:/if_stage/instruction_memory/memory"

# Initialize clock
force -freeze -repeat 100ns "sim:/if_stage/clk" 0 0ns, 1 50ns

# Test predicted address
set time 0
# Set input predicted address to anything
force -freeze "sim:/if_stage/predicted_address_in" 32'h00000012 $time
# Output predicted address should be input predicted address on clk

# Test fallback address
set time [expr $time + 100]
# Set input fallback address to anything
force -freeze "sim:/if_stage/fallback_address_in" 32'h00000003 $time
# Output fallback address should be input fallback address on clk

# Test instruction
set time [expr $time + 100]
# Set pc to anything within instruction space (aligned by word)
force -freeze "sim:/if_stage/pc" 32'h0000000C $time
# Output instruction should be instruction at pc on clk

# Test branch
set time [expr $time + 100]
# Set branch to 1
force -freeze "sim:/if_stage/branch" 1 $time
# Instruction should be 0

# Run
set time [expr $time + 100]
run $time
