"""
Generates support.tcl script for project
"""
import os
import re

# Find vhdl files
vhd_file = re.compile(r'\w+\.vhd')

# Simulate procedure file
simulate='''
proc sim_start {} {
    vsim work.cpu
    add wave sim:/cpu/clk
    add wave sim:/cpu/NextPC
    add wave sim:/cpu/PC
    add wave sim:/cpu/Instruction
    add wave sim:/cpu/DMemory/memFile
    add wave sim:/cpu/Register1/regFile
	sim_set
}

proc sim_reset {} {
	restart
	sim_set
}

proc sim_set {} {
    force -freeze sim:/cpu/clk 1 0, 0 {50 ns} -r 100
    force -freeze sim:/cpu/NextPC 32'h0 0 -cancel 10
    mem load -filltype value -fillradix hexadecimal -filldata {
        00000000
    } -startaddress 0 -endaddress 0 /cpu/Register1/regFile
    mem load -filltype value -fillradix hexadecimal -filldata {
        00000000 00000004 00000004
    } -startaddress 8 -endaddress 10 /cpu/Register1/regFile
    mem load -filltype value -fillradix hexadecimal -filldata {
        0000000C 00000005 00000008 00000003
    } -startaddress 20 -endaddress 23 /cpu/Register1/regFile
    mem load -filltype value -fillradix hexadecimal -filldata {
        00 00 00 04
        00 00 00 08
    } -startaddress 0 -endaddress 7 /cpu/DMemory/memFile
    mem load -filltype value -fillradix hexadecimal -filldata {00} /cpu/InstMem/memFile
}

proc sim_run {} {
    run 1000ns
}

proc sim_load_example_1 {} {
    sim_reset
    mem load -filltype value -filldata {
        8D 15 00 00
        8D 16 00 04
        02 B6 78 2A
        11 E0 00 02
        02 43 88 22
        08 00 00 07
        02 53 88 20
        AD 11 00 0C
    } -fillradix hexadecimal -startaddress 0 -endaddress 31 /cpu/InstMem/memFile
}

proc sim_load_example_2 {} {
    sim_reset
    mem load -filltype value -filldata {
        EB A0 00 04
        EF B0 00 00
    } -fillradix hexadecimal -startaddress 0 -endaddress 7 /cpu/InstMem/memFile
}
'''

with open('support.tcl', 'w+') as support_file:
    #
    # Writing support file
    #

    # Compile procedure
    support_file.write('proc compile_all {} {\n')
    for filename in os.listdir():
        if vhd_file.match(filename):
            support_file.write('\tvcom -work work ' + filename + '\n')
    support_file.write('}\n')

    # Simulate procedure
    support_file.write(simulate)
