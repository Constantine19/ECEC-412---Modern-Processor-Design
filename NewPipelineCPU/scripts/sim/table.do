# Start simulation
vsim table

# Windows
noview sim
noview objects
view -dock transcript
view -dock memory
view -dock wave

# Add waves
add wave -group "CPU Clock" -color "Grey60" -label "Clock" "sim:/table/clk"
add wave -group "Inputs" -color "Magenta" -label "Address" "sim:/table/addr"
add wave -group "Inputs" -color "Magenta" -label "Write Value" "sim:/table/wvalue"
add wave -group "Inputs" -color "Magenta" -label "Write" "sim:/table/write"
add wave -group "Output" -color "Cyan" -label "Read Value" "sim:/table/rvalue"

# Set memory
mem load -filltype value -fillradix hexadecimal -filldata {
    ACC9F384 FCD6C8BB 9415CE5F 6BB03402
    8653DB4B 03A29653 98B46640 4478BBD9
    A14D5D6E DEEAF1FF CB52D696 0971E2FE
    5EA7016E F29F6137 A53ACA72 E141ED01
    5A9074D7 C3897DEA BEC5E206 7894BC43
    1EB10AF1 ECA200AE 9EEFEFBB 0D25C13E
    9DC95AA4 A9F7FFAD D97BC6FC 3FD545CD
} -startaddress 0 -endaddress 31 "sim:/table/table"

# Add patterns
force -freeze -repeat 100ns "sim:/table/clk" \
    0 0ns, \
    1 50ns
force -freeze "sim:/table/addr" \
    32'h00000000 0ns, \
    32'h00000004 120ns, \
    32'h00000008 220ns, \
    32'h0000000F 320ns, \
    32'h00000010 420ns, \
    32'h00000012 520ns
force -freeze "sim:/table/write" \
    0 0ns, \
    1 620ns
force -freeze "sim:/table/wvalue" \
    32'h00000000 0ns, \
    32'h1A2B3C4D 620ns, \
    32'hFFEEDDCC 720ns, \
    32'hF9E8D7C6 820ns

# Run for 1000ns
run 1000ns
