# Start simulation
vsim reg1

# Windows
noview sim
view transcript
view wave

# Add waves
add wave -color "Grey60"  -label "Clock"  "sim:/reg1/clk"
add wave -color "Magenta" -label "Input"  "sim:/reg1/x"
add wave -color "Cyan"    -label "Output" "sim:/reg1/y"

# Add patterns
force -freeze -repeat 100ns "sim:/reg1/clk" \
    0 0ns, \
    1 50ns
force -freeze "sim:/reg1/x" \
    1 0ns, \
    0 60ns

# Run simulations
run 400ns
