# Start simulation
vsim handle_jump

# Windows
noview sim
noview objects
view transcript
view memory
view wave

# Add Waves
add wave -group "Inputs" -color "Red" -label "Jump Code" "sim:/handle_jump/jump_code"
add wave -group "Inputs" -color "Red" -label "PC" "sim:/handle_jump/pc"
add wave -group "Inputs" -color "Red" -label "Predicted Address" "sim:/handle_jump/predicted_address"
add wave -group "Inputs" -color "Red" -label "Jump" "sim:/handle_jump/jump"
add wave -group "Intermediaries" -color "Green" -label "Full Jump Address" "sim:/handle_jump/full_jump_address"
add wave -group "Intermediaries" -color "Green" -label "Not Equal" "sim:/handle_jump/not_equal"
add wave -group "Outputs" -color "Cyan" -label "Jump Address" "sim:/handle_jump/jump_address"
add wave -group "Outputs" -color "Cyan" -label "Jump Execute" "sim:/handle_jump/jump_execute"

# Add patterns

# Jump address should be jump code with 2 '0's concatenated at the end and the
# most significant four bits from pc concatenated at the start
# ------------------------------------------------------------------------------
set time 0
# Set jump to 0
force -freeze "sim:/handle_jump/jump" 0 $time
# Set Jump Code to anything
force -freeze "sim:/handle_jump/jump_code" 26'h0654321 $time
# Set PC to anything
force -freeze "sim:/handle_jump/pc" 32'hA1B2C3D4 $time

# Jump execute should be 0 if jump address equals predicted address
# ------------------------------------------------------------------------------
set time [expr $time + 100]
# Set jump to 1
force -freeze "sim:/handle_jump/jump" 1 $time
# Set predicted address to jump address
force -freeze "sim:/handle_jump/predicted_address" 32'hA1950C84 $time

# Jump execute should be 1 if jump is 1 and jump address does not equal
# predicted address
# ------------------------------------------------------------------------------
set time [expr $time + 100]
# Set jump to 1
force -freeze "sim:/handle_jump/jump" 1 $time
# Set predicted address to anything but jump address
force -freeze "sim:/handle_jump/predicted_address" 32'hA1234567 $time

# Jump execute should be 0 if jump is 0 and jump address does not equal
# predicted address
# ------------------------------------------------------------------------------
set time [expr $time + 100]
# Set jump to 1
force -freeze "sim:/handle_jump/jump" 0 $time
# Set predicted address to anything but jump address
force -freeze "sim:/handle_jump/predicted_address" 32'hA1234567 $time

# Run
set time [expr $time + 100]
run $time
