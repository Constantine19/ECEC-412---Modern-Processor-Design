"""
Generates support.tcl script for project
"""
import os
import re

# Constants
INSTRUCTION_MEMORY='/cpu/InstMem/memFile'
DATA_MEMORY='/cpu/DMemory/memFile'
REGISTER_MEMORY='/cpu/Register1/regFile'
CONTROLLER = '/cpu/Control1'

# --------------------------------- FUNCTIONS ---------------------------------

def flat(lst):
    """
    Flattens the given list. Concatenates all sublists into one

    :param lst: list of lists/values

    :return: flattened list
    """
    nlst = []
    for value in lst:
        if type(value) is list:
            nlst.extend(value)
        else:
            nlst.append(value)
    return nlst

def procedure(name, lines):
    """
    Tcl Procedure

    :param name: name of procedure
    :param lines: lines of procedure

    :return: tcl procedure string
    """
    return 'proc '+name+' {} {\n'+'\n'.join('\t'+line for line in lines)+'\n}'

def wave_group(name, color, signals):
    """
    An array of wave declarations all in the same group

    :param name: the name of the wave group
    :param color: the color of the wave group
    :param signals: signals (name, identifier pairs) in the group

    :return: array of wave declarations for the group
    """
    return [f'add wave -group "{name}" -color "{color}" -label "{sig[0]}" "{sig[1]}"' for sig in signals]

def mem_load(dest, start, fmt, data):
    """
    Tcl command to load memory data into memory location (assuming all memory
    is to be written)

    :param dest: identifier for destination memory location
    :param start: start location for writing memory
    :param fmt: format of memory to write
    :param data: data to write into memory

    :return: mem load Tcl command
    """
    endd = start + len(data) - 1
    dstr = '{' + ' '.join(format(value, fmt) for value in data) + '}'
    return 'mem load -filltype value -fillradix hexadecimal ' \
        + f'-startaddress {start} -endaddress {endd} -filldata {dstr} {dest}'

def mem_load_all(dest, fmt, datas):
    """
    Load all chunks into same destination memory

    :param dest: destination memory location
    :param fmt: format of memory to write
    :param data: chunks of data to write (position, data pairs)

    :return: array of tcl commands
    """
    return [mem_load(dest, start, fmt, data) for start, data in datas]

def mem_clear(dest):
    """
    Tcl command to clear all set all data in a memory location

    :param dest: identifier for destination memory location

    :return: mem clear Tcl command
    """
    return 'mem load -filltype value -fillradix hexadecimal -filldata {00} ' + dest

def clock(signal):
    """
    Declare clock signal

    :param signal: identifer for signal to force clock

    :return: declaration tcl command
    """
    return 'force -freeze '+signal+' 1 0, 0 {50 ns} -r 100'

def signal_for(time, signal, value):
    """
    Force a signal value for a given time

    :param time: the time to set for
    :param signal: identifer for signal to force
    :param value: value of signal to force

    :return: declaration tcl command
    """
    return f'force -freeze {signal} {value} 0 -cancel {time}'

def compile(component):
    """
    Compile component in work library

    :param component: vhdl file of the component

    :return: compile tcl command
    """
    return f'vcom -work work {component}'

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

support_script = '\n'.join([
    procedure('compileall', [
        compile(file) for file in os.listdir() if file.endswith('.vhd')
    ]),

    # Sim utility functions
    procedure('simset', flat([
        clock('sim:/cpu/clk'),
        signal_for(10, 'sim:/cpu/NextPC', '32\'h0'),
        mem_load_all(REGISTER_MEMORY, '08X', [
            ( 0, [0x00000000]),
            ( 8, [0x00000000, 0x00000004, 0x00000004]),
            (20, [0x0000000C, 0x00000005, 0x00000008, 0x00000003])
        ]),
        mem_load(DATA_MEMORY, 0, '02X', [
            0x00, 0x00, 0x00, 0x04,
            0x00, 0x00, 0x00, 0x08
        ]),
        mem_clear(INSTRUCTION_MEMORY)
    ])),
    procedure('simreset', [
        'restart',
        'simset'
    ]),

    # Wave groups
    declare_wave_groups([
        wave_group('Instruction', 'Grey60', [
            ('Clock', 'sim:/cpu/clk'),
            ('Next PC', 'sim:/cpu/NextPC'),
            ('PC', 'sim:/cpu/PC'),
            ('Instruction', 'sim:/cpu/Instruction')
        ]),
        wave_group('Memory Files', 'Medium Orchid', [
            ('Data Memory', 'sim:/cpu/DMemory/memFile'),
            ('Registers', f'sim:{REGISTER_MEMORY}')
        ]),
        wave_group('Control Signals', 'Orange', [
            ('Opcode', f'sim:{CONTROLLER}/Opcode'),
            ('RegDst', f'sim:{CONTROLLER}/RegDst'),
            ('Branch', f'sim:{CONTROLLER}/Branch'),
            ('MemRead', f'sim:{CONTROLLER}/MemRead'),
            ('MemtoReg', f'sim:{CONTROLLER}/MemtoReg'),
            ('MemWrite', f'sim:{CONTROLLER}/MemWrite'),
            ('ALUSrc', f'sim:{CONTROLLER}/ALUSrc'),
            ('RegWrte', f'sim:{CONTROLLER}/RegWrite'),
            ('Jump', f'sim:{CONTROLLER}/Jump'),
            ('AluOp', f'sim:{CONTROLLER}/ALUOp'),
            ('StackOps', f'sim:{CONTROLLER}/StackOps')
        ])
    ]),

    # Programs
    program('example1', [
        0x8D, 0x15, 0x00, 0x00,
        0x8D, 0x16, 0x00, 0x04,
        0x02, 0xB6, 0x78, 0x2A,
        0x11, 0xE0, 0x00, 0x02,
        0x02, 0x43, 0x88, 0x22,
        0x08, 0x00, 0x00, 0x07,
        0x02, 0x53, 0x88, 0x20,
        0xAD, 0x11, 0x00, 0x0C
    ]),
    program('example2', [
        0xEB, 0xA0, 0x00, 0x04,
        0xEF, 0xB0, 0x00, 0x00
    ]),

    # Run for 10 clock cycles
    runfor(10)
])

# Write support script
def main():
    with open('support.tcl', 'w+') as support_file:
        support_file.write(support_script)

if __name__ == '__main__':
    main()
