# Start simulation
vsim btb_predictor

# Windows
noview sim
noview objects
view transcript
view memory
view wave

# Add waves
add wave -group "CPU Clock" -color "Grey60" -label "Clock" "sim:/btb_predictor/clk"
add wave -group "Inputs" -color "Magenta" -label "PC" "sim:/btb_predictor/pc"
add wave -group "Inputs" -color "Magenta" -label "Next Address" "sim:/btb_predictor/next_address"
add wave -group "Inputs" -color "Magenta" -label "Branch" "sim:/btb_predictor/branch"
add wave -group "Intermediaries" -color "Orange" -label "Hit" "sim:/btb_predictor/hit"
add wave -group "Intermediaries" -color "Orange" -label "Hit Address" "sim:/btb_predictor/read_value"
add wave -group "Outputs" -color "Cyan" -label "Predicted Address" "sim:/btb_predictor/predicted_address"
add wave -group "Outputs" -color "Cyan" -label "Fallback Address" "sim:/btb_predictor/fallback_address"

# Clear branch memory
mem load -filltype value -fillradix hexadecimal -filldata {33'h0} \
    "sim:/btb_predictor/branch_table/table"

# Add patterns

# Clock
force -freeze -repeat 100ns "sim:/btb_predictor/clk" 0 0ns, 1 50ns

# Check a miss
set time 0ns

# Set pc to anything
force -freeze "sim:/btb_predictor/pc" 32'h00000012 $time
# Set branch to 0
force -freeze "sim:/btb_predictor/branch" 0 $time
# Predicted address should equal pc + 4
# Fallback address should equal pc + 4

# Execute a branch
set time 100ns

# Set pc to anything
force -freeze "sim:/btb_predictor/pc" 32'h00000012 $time
# Set branch to 1
force -freeze "sim:/btb_predictor/branch" 1 $time
# Set next address to anything else
force -freeze "sim:/btb_predictor/next_address" 32'hABCDEF00 $time
# Predicted address should be branch address
# Fallback address should be pc+4
# branch_table at address equal to pc should be set to next address

# Check a hit
set time 200ns

# Set pc to same as last
force -freeze "sim:/btb_predictor/pc" 32'h00000012 $time
# Set branch to 0
force -freeze "sim:/btb_predictor/branch" 0 $time
# Predicted address should be branch address
# Fallback address should be pc+4

# Run for 300ns
run 300ns
