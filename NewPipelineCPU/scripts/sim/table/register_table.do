# Start simulation
vsim register_table

# Windows
noview sim
noview objects
view transcript
view memory
view wave

# Add waves
add wave -group "CPU Clock" -color "Grey60" -label "Clock" "sim:/register_table/clk"
add wave -group "Inputs" -color "Magenta" -label "Read Address 1" "sim:/register_table/raddr1"
add wave -group "Inputs" -color "Magenta" -label "Read Address 2" "sim:/register_table/raddr2"
add wave -group "Inputs" -color "Magenta" -label "Write Address" "sim:/register_table/waddr"
add wave -group "Inputs" -color "Magenta" -label "Write Value" "sim:/register_table/wvalue"
add wave -group "Inputs" -color "Magenta" -label "Write" "sim:/register_table/write"
add wave -group "Inputs" -color "Magenta" -label "Stack Op" "sim:/register_table/stackop"
add wave -group "Output" -color "Cyan" -label "Read Value 1" "sim:/register_table/rvalue1"
add wave -group "Output" -color "Cyan" -label "Read Value 2" "sim:/register_table/rvalue2"

# Set memory
mem load -filltype value -fillradix hexadecimal -filldata {
    ACC9F384 FCD6C8BB 9415CE5F 6BB03402
    8653DB4B 03A29653 98B46640 4478BBD9
    A14D5D6E DEEAF1FF CB52D696 0971E2FE
    5EA7016E F29F6137 A53ACA72 E141ED01
    5A9074D7 C3897DEA BEC5E206 7894BC43
    1EB10AF1 ECA200AE 9EEFEFBB 0D25C13E
    9DC95AA4 A9F7FFAD D97BC6FC 3FD545CD
} -startaddress 0 -endaddress 31 "sim:/register_table/table"

# Add patterns

# Clock
force -freeze -repeat 100ns "sim:/register_table/clk" 0 0ns, 1 50ns

# Read two values
force -freeze "sim:/register_table/raddr1" 5'h00 0ns, 5'h01 100ns, 5'h0C 200ns, 5'h13 300ns
force -freeze "sim:/register_table/raddr2" 5'h00 0ns, 5'h04 100ns, 5'h15 200ns, 5'h1A 300ns

# Read stack pointer
force -freeze "sim:/register_table/stackop" 0 0ns, 1 400ns, 0 500ns

# Write a value
force -freeze "sim:/register_table/raddr1" 5'h15 500ns
force -freeze "sim:/register_table/waddr" 5'h15 500ns
force -freeze "sim:/register_table/wvalue" 5'h1A2B3C4D 500ns
force -freeze "sim:/register_table/write" 0 0ns, 1 500ns

# Run for 200ns
run 700ns
