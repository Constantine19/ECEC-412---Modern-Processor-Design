# Start simulation
vsim alu

# Windows
noview sim
noview objects
view transcript
view wave

# Add waves
add wave -group "Inputs" -color "Magenta" -label "Input A" "sim:/alu/a"
add wave -group "Inputs" -color "Magenta" -label "Input B" "sim:/alu/b"
add wave -color "Green" -radix "binary" -label "Operation" "sim:/alu/oper"
add wave -group "Intermediaries" -color "Orange" -label "Carry" "sim:/alu/c"
add wave -group "Outputs" -color "Cyan" -label "Result" "sim:/alu/res"
add wave -group "Outputs" -color "Cyan" -label "Zero" "sim:/alu/zero"
add wave -group "Outputs" -color "Cyan" -label "Overflow" "sim:/alu/overflow"

# Add patterns

# Add
set time 0ns
force -freeze "sim:/alu/a" 32'h00001234 $time
force -freeze "sim:/alu/b" 32'h0000ABCD $time
force -freeze "sim:/alu/oper" 32'b0010 $time

# 7FFFFFFF + 1 = -77FFFFFFF

# -7FFFFFFF
# 1000 0000 0000 0000 0000 0000 0000 0001

# Add overflow
set time 100ns
force -freeze "sim:/alu/a" 32'h7FFFFFFF $time
force -freeze "sim:/alu/b" 32'h00000001 $time
force -freeze "sim:/alu/oper" 32'b0010 $time

# Subtract
set time 200ns
force -freeze "sim:/alu/a" 32'h0000ABCD $time
force -freeze "sim:/alu/b" 32'h00001234 $time
force -freeze "sim:/alu/oper" 32'b0110 $time

# Subtract to zero
set time 300ns
force -freeze "sim:/alu/a" 32'h0000ABCD $time
force -freeze "sim:/alu/b" 32'h0000ABCD $time
force -freeze "sim:/alu/oper" 32'b0110 $time

# Subtract overflow
set time 400ns
force -freeze "sim:/alu/a" 32'h80000001 $time
force -freeze "sim:/alu/b" 32'h00000002 $time
force -freeze "sim:/alu/oper" 32'b0110 $time

# SLT Less than
set time 500ns
force -freeze "sim:/alu/a" 32'h00001234 $time
force -freeze "sim:/alu/b" 32'h0000ABCD $time
force -freeze "sim:/alu/oper" 32'b0111 $time

# SLT Greater Than
set time 600ns
force -freeze "sim:/alu/a" 32'h0000ABCD $time
force -freeze "sim:/alu/b" 32'h00001234 $time
force -freeze "sim:/alu/oper" 32'b0111 $time

# Run for 700ns
run 700ns
