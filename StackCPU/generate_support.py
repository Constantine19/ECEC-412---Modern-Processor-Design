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
    force -freeze sim:/cpu/NextPC 32'h0 0 -cancel 110
}\n

proc sim_run {} {
    run 1000ns
}\n
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
