# Start simulation
vsim readonly_mem

# Windows
noview sim
noview objects
view transcript
view memory
view wave

# Add waves
add wave -color "Magenta" -label "Address" "sim:/readonly_mem/addr"
add wave -color "Cyan"    -label "Data"    "sim:/readonly_mem/data"

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
} -startaddress 0 -endaddress 128 "sim:/readonly_mem/memory"

# Add patterns
force -freeze "sim:/readonly_mem/addr" \
    32'h00000000 0ns, \
    32'h00000010 100ns, \
    32'h00000014 200ns, \
    32'h00000024 300ns, \
    32'h0000004C 400ns, \
    32'h0000008C 500ns

# Run for 600ns
run 600ns
