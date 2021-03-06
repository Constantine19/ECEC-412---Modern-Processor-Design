# Start simulation
vsim alu1

# Windows
noview sim
noview objects
view transcript
view wave

# Add waves
add wave -group "Inputs" -color "Magenta" -label "Input A" "sim:/alu1/a"
add wave -group "Inputs" -color "Magenta" -label "Input B" "sim:/alu1/b"
add wave -group "Inputs" -color "Magenta" -label "Carry In" "sim:/alu1/cin"
add wave -group "Inputs" -color "Magenta" -label "Less" "sim:/alu1/less"
add wave -color "Green" -radix "binary" -label "Operation" "sim:/alu1/oper"
add wave -group "Intermediaries" -color "Orange" -label "True A" "sim:/alu1/atrue"
add wave -group "Intermediaries" -color "Orange" -label "True B" "sim:/alu1/btrue"
add wave -group "Outputs" -color "Cyan" -label "Result" "sim:/alu1/res"
add wave -group "Outputs" -color "Cyan" -label "Carry Out" "sim:/alu1/cout"
add wave -group "Outputs" -color "Cyan" -label "Set" "sim:/alu1/set"

# Add patterns

# Start with add
force -freeze "sim:/alu1/a" 0 0ns
force -freeze "sim:/alu1/b" 1 0ns
force -freeze "sim:/alu1/cin" 0 0ns
force -freeze "sim:/alu1/less" 0 0ns
force -freeze "sim:/alu1/oper" 4'b0010 0ns
force -freeze "sim:/alu1/a" 1 50ns
force -freeze "sim:/alu1/b" 0 50ns

# Intermediaries
force -freeze "sim:/alu1/a" 0 100ns
force -freeze "sim:/alu1/b" 0 100ns
force -freeze "sim:/alu1/oper" 4'b0000 100ns, 4'b0100 150ns, 4'b1000 200ns, 4'b1100 250ns

# And
force -freeze "sim:/alu1/a" 0 300ns, 1 350ns, 0 400ns, 1 450ns
force -freeze "sim:/alu1/b" 0 300ns, 1 400ns
force -freeze "sim:/alu1/cin" 0 300ns
force -freeze "sim:/alu1/less" 0 300ns
force -freeze "sim:/alu1/oper" 4'b0000 300ns

# Or
force -freeze "sim:/alu1/a" 0 500ns, 1 550ns, 0 600ns, 1 650ns
force -freeze "sim:/alu1/b" 0 500ns, 1 600ns
force -freeze "sim:/alu1/oper" 4'b0001 500ns

# Add
force -freeze "sim:/alu1/a" 0 700ns, 1 750ns, 0 800ns, 1 850ns, 0 900ns, 1 950ns, 0 1000ns, 1 1050ns
force -freeze "sim:/alu1/b" 0 700ns, 1 800ns, 0 900ns, 1 1000ns
force -freeze "sim:/alu1/cin" 0 0ns, 1 900ns
force -freeze "sim:/alu1/oper" 4'b0010 700ns

# Less
force -freeze "sim:/alu1/a" 0 1100ns, 1 1150ns, 0 1200ns, 1 1250ns, 0 1300ns, 1 1350ns, 0 1400ns, 1 1450ns
force -freeze "sim:/alu1/b" 0 1100ns, 1 1200ns, 0 1300ns, 1 1400ns
force -freeze "sim:/alu1/cin" 0 1100ns, 1 1300ns
force -freeze "sim:/alu1/less" 0 0ns, 1 1100ns
force -freeze "sim:/alu1/oper" 4'b0011 1100ns

# Run for 1400ns
run 1500ns
