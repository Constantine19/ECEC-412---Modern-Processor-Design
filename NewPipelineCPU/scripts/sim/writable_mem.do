# Start simulation
vsim writable_mem

# Windows
noview sim
noview objects
view -dock transcript
view -dock memory
view -dock wave

# Add waves
add wave -group "CPU Clock" -color "Grey60" -label "Clock" "sim:/writable_mem/clk"
add wave -group "Inputs" -color "Magenta" -label "Address" "sim:/writable_mem/addr"
add wave -group "Inputs" -color "Magenta" -label "Write Data" "sim:/writable_mem/wdata"
add wave -group "Inputs" -color "Magenta" -label "Write" "sim:/writable_mem/write"
add wave -group "Outputs" -color "Cyan" -label "Read Data" "sim:/writable_mem/rdata"

# Set memory
mem load -filltype value -fillradix hexadecimal -filldata {
    53 A8 28 3C    B3 14 D3 4F    F2 1C FF 42    FE E3 F5 9B
    1E 03 8D 19    3A 4E F7 99    FC D7 7C 6B    AD 4C 2B 26
    9C E1 AF 7C    D6 78 0A 73    D8 C6 74 0C    EE CA 87 85
    71 C3 FD C8    91 72 83 A5    49 AB 87 DE    76 4E 00 FE
    A8 8B 2E AA    B0 D9 31 77    E9 24 C7 57    5F 9D 20 04
    CC 5D 23 FE    F2 59 DB F6    84 70 6D BB    00 2D 39 2C
    72 9C 11 89    01 B7 51 1E    22 4F C9 25    35 E5 6D 9C
    17 24 0E 85    B4 D8 E5 AA    A2 38 80 42    26 26 6B 1E
} -startaddress 0 -endaddress 128 "sim:/writable_mem/memory"

# Add patterns
force -freeze -repeat 100ns "sim:/writable_mem/clk" \
    0 0ns, \
    1 50ns
force -freeze "sim:/writable_mem/addr" \
    32'h00000000 0ns, \
    32'h00000010 120ns, \
    32'h00000014 220ns, \
    32'h00000024 320ns, \
    32'h0000004C 420ns, \
    32'h0000008C 520ns
force -freeze "sim:/writable_mem/write" \
    0 0ns, \
    1 620ns
force -freeze "sim:/writable_mem/wdata" \
    32'h00000000 0ns, \
    32'h3A2B4D8F 620ns, \
    32'h5C3E5EFF 720ns, \
    32'h432ABE22 820ns

# Run for 1000ns
run 1000ns
