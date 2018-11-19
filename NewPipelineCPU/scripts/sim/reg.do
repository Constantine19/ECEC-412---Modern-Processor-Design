# Start simulation
vsim reg

# Windows
noview sim
view transcript
view wave

# Add waves
add wave -color "Grey60"  -label "Clock"  "sim:/reg/clk"
add wave -color "Magenta" -label "Input"  "sim:/reg/x"
add wave -color "Cyan"    -label "Output" "sim:/reg/y"

# Add patterns
force -freeze -repeat 100ns "sim:/reg/clk" \
    0 0ns, \
    1 50ns
force -freeze "sim:/reg/x" \
    32'h00000000 0ns, \
    32'h00000001 60ns, \
    32'h0000000A 160ns, \
    32'h09800C1F 260ns, \
    32'h0CF8D14D 360ns, \
    32'h1A2B3C4D 460NS

# Run simulations
run 500ns
