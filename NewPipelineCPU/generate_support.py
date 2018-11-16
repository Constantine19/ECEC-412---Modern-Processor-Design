"""
Generates support.tcl script for project
"""
import os
import re
from support_script import *

# Constants
INSTRUCTION_MEMORY='/cpu/IFStage/InstMem/memFile'
DATA_MEMORY='/cpu/MEMStage/DataMem/memFile'
REGISTER='/cpu/IDStage/Registers1'
REGISTER_MEMORY=f'{REGISTER}/regFile'
CONTROLLER = '/cpu/Controller'

# ----------------------------- POCEDURE TEMPLATES -----------------------------

def declare_wave_groups(wave_groups):
    """
    Declare wave groups on simulation start

    :param wave_groups: the wave groups to declare

    :return: tcl procedure
    """
    return procedure("simstart", flat(
        ['vsim work.cpu'] + wave_groups + ['simset']
    ))

def program(name, data):
    """
    Loads a program

    :param name: the name of the program
    :param data: the data to set in the program

    :return: tcl procedure
    """
    return procedure(f'simload{name}', [
        'simreset',
        mem_load(INSTRUCTION_MEMORY, 0, '02X', data)
    ])

def runfor(clocks):
    """
    Run the simulation for the given number of clock cycles

    :param clocks: number of clock cycles to run for

    :return: tcl procedure
    """
    return procedure('simrun', [
        f'run {100*clocks}ns'
    ])

# ----------------------------------- SCRIPT -----------------------------------

script = '\n'.join([
    procedure('init', [
        'vlib work'
    ]),

    procedure('compileall', [
        compile(file) for file in os.listdir() if file.endswith('.vhd')
    ]),

    # # Sim utility functions
    # procedure('simset', flat([
    #     clock('sim:/cpu/clk'),
    #     mem_load_all(REGISTER_MEMORY, '08X', [
    #         ( 0, [0x00000000]),
    #         ( 8, [0x00000000, 0x00000004, 0x00000004]),
    #         (20, [0x0000000C, 0x00000005, 0x00000008, 0x00000003]),
    #         (29, [0x000000F8])
    #     ]),
    #     mem_load(DATA_MEMORY, 0, '02X', [
    #         0x00, 0x00, 0x00, 0x04,
    #         0x00, 0x00, 0x00, 0x08
    #     ]),
    #     mem_clear(INSTRUCTION_MEMORY)
    # ])),
    # procedure('simreset', [
    #     'restart',
    #     'simset'
    # ]),
    #
    # # Wave groups
    # declare_wave_groups([
    #     wave_group('CPU Clock', 'Grey60', [
    #         ('Clock', 'sim:/cpu/clk'),
    #     ])
    # ]),
    #
    # # Programs
    # program('example', [
    #     0x8C, 0x08, 0x00, 0x00, # lw $t0 $zero 0
    #     0x8C, 0x09, 0x00, 0x04, # lw $t1 $zero 4
    #     0x01, 0x09, 0x50, 0x20, # add $t2 $t1 $t0
    #     0xAC, 0x0A, 0x00, 0x08  # sw $t2 $zero 8
    # ]),
    #
    # # Run for 10 clock cycles
    # runfor(22)
])

# Write support script
def main():
    with open('support.tcl', 'w+') as file:
        file.write(script)

if __name__ == '__main__':
    main()
