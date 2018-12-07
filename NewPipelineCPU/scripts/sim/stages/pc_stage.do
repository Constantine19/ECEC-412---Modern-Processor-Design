# Start simulation
vsim pc_stage

# Windows
noview sim
noview objects
view transcript
view memory
view wave

# Add Waves
add wave -group "CPU Clock" -color "Grey60" -label "Clock" "sim:/pc_stage/clk"
add wave -group "Inputs" -color "Red" -label "Branch Address" "sim:/pc_stage/branch_address"
add wave -group "Inputs" -color "Red" -label "Branch Command" "sim:/pc_stage/branch_command"
add wave -group "Intermediaries" -color "Orange" -label "Delayed Clock" "sim:/pc_stage/delayed_clk"
add wave -group "Intermediaries" -color "Orange" -label "PC - D" "sim:/pc_stage/d_pc"
add wave -group "Outputs" -color "Cyan" -label "PC" "sim:/pc_stage/pc"
add wave -group "Outputs" -color "Cyan" -label "Predicted Address" "sim:/pc_stage/predicted_address"
add wave -group "Outputs" -color "Cyan" -label "Fallback Address" "sim:/pc_stage/fallback_address"

# Set memory
mem load -filltype value -fillradix hexadecimal -filldata {0} \
    "sim:/pc_stage/branch_target_buffer/branch_table/table"

# Initialize clock
force -freeze -repeat 100ns "sim:/pc_stage/clk" 0 0ns, 1 50ns

# Initialize program counter
force -freeze -cancel 10ns "sim:/pc_stage/pc" 0 0ns

# Test Incrementing Program Counter
force -freeze "sim:/pc_stage/branch_command" 0 0ns
# Predicted address should be pc + 4
# Fallback address should be pc + 4
# Instruction should be instruction at pc

# Test Branch Command (branching back)
# Set branch command
force -freeze "sim:/pc_stage/branch_command" 1 800ns
# Set branch address
force -freeze "sim:/pc_stage/branch_address" 32'h0000000C 800ns
# Predicted address should be jump address
# Fallback Address should be pc + 4

# Increment until pc address is at the address when branch was executed
# Set branch command
force -freeze "sim:/pc_stage/branch_command" 0 900ns
# Predicted address should be jump address
# Fallback Address should be pc + 4

# Test Branch Command (branching forward)
# Set branch command
force -freeze "sim:/pc_stage/branch_command" 1 2000ns
# Set branch address
force -freeze "sim:/pc_stage/branch_address" 32'h00000024 2000ns
# Predicted address should be branch address
# Fallback Address should be pc + 4

# Clear
# Set branch to 0
force -freeze "sim:/pc_stage/branch_command" 0 2100ns

# Run
run 2400ns
