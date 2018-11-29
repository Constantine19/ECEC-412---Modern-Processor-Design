# Start simulation
vsim mux

# Windows
noview sim
noview objects
view transcript
view wave

# Add Waves
add wave -group "Inputs" -color "Magenta" -label "X" "sim:/mux/x"
add wave -group "Inputs" -color "Magenta" -label "Y" "sim:/mux/y"
add wave -color "Green" -label "Select" "sim:/mux/sel"
add wave -group "Outputs" -color "Cyan" -label "Z" "sim:/mux/z"

# Add Patterns
force -freeze "sim:/mux/x" 32'h01234567 0ns
force -freeze "sim:/mux/y" 32'h89ABCDEF 0ns
force -freeze "sim:/mux/sel" 0 0ns, 1 100ns

# Run for 200ns
run 200ns
