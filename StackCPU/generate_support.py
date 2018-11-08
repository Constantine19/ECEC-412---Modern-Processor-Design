"""
Generates support.tcl script for project
"""
import os
import re

def flat(lst):
    nlst = []
    for value in lst:
        if type(value) is list:
            nlst.extend(value)
        else:
            nlst.append(value)
    return nlst

def procedure(name, lines):
    return 'proc '+name+' {} {'+''.join('\n\t'+line for line in lines)+'\n}\n'

def wave_group(name, color, signals):
    return [f'add wave -group {name} -color {color} -label "{sig[0]}" {sig[1]}' for sig in signals]

def mem_load(dest, start, fmt, data):
    endd = start + len(data) - 1
    dstr = '{' + ' '.join(format(value, fmt) for value in data) + '}'
    return 'mem load -filltype value -fillradix hexadecimal ' \
        + f'-startaddress {start} -endaddress {endd} -filldata {dstr} {dest}'

def mem_clear(dest):
    return 'mem load -filltype value -fillradix hexadecimal -filldata {00} ' + dest

def clock(signal):
    return 'force -freeze '+signal+' 1 0, 0 {50 ns} -r 100'

def signal_for(time, signal, value):
    return f'force -freeze {signal} {signal} 0 -cancel {time}'

def duplicate(value):
    return value, value

INSTRUCTION_MEMORY='/cpu/InstMem/memFile'
DATA_MEMORY='/cpu/DMemory/memFile'
REGISTER_MEMORY='/cpu/Register1/regFile'

simulate = '\n'.join([
    procedure('sim_start', flat([
        'vsim work.cpu',
        wave_group('Instruction', 'Grey60', [
            ('Clock', 'sim:/cpu/clk'),
            ('Next PC', 'sim:/cpu/NextPC'),
            ('PC', 'sim:/cpu/PC'),
            ('Instruction', 'Instruction')
        ]),
        wave_group('Memory Files', 'Medium Orchid', [
            ('Data Memory', 'sim:/cpu/DMemory/memFile'),
            ('Registers', f'sim:{REGISTER_MEMORY}')
        ]),
        wave_group('Control Signals', 'Orange', map(duplicate, [
            'BranchOpResult',
            'RegDst',
            'Branch',
            'MemRead',
            'MemtoReg',
            'MemWrite',
            'ALUSrc',
            'RegWrte',
            'Jump',
            'AluOp',
            'StackOps'
        ])),
        'sim_set'
    ])),

    procedure('sim_reset', [
        'restart',
        'sim_set'
    ]),

    procedure('sim_set', [
        clock('sim:/cpu/clk'),
        signal_for(10, 'sim:/cpu/NextPC', '32\'h0'),
        mem_load(REGISTER_MEMORY, 0, '08X', [0]),
        mem_load(REGISTER_MEMORY, 8, '08X', [
            0x00000000, 0x00000004, 0x00000004
        ]),
        mem_load(REGISTER_MEMORY, 20, '08X', [
            0x0000000C, 0x00000005, 0x00000008, 0x00000003
        ]),
        mem_load(DATA_MEMORY, 0, '02X', [
            0x00, 0x00, 0x00, 0x04,
            0x00, 0x00, 0x00, 0x08
        ]),
        mem_clear(INSTRUCTION_MEMORY)
    ]),

    procedure('sim_run', [
        'run 1000ns'
    ]),

    procedure('sim_load_example_1', [
        'sim_reset',
        mem_load(INSTRUCTION_MEMORY, 0, '02X', [
            0x8D, 0x15, 0x00, 0x00,
            0x8D, 0x16, 0x00, 0x04,
            0x02, 0xB6, 0x78, 0x2A,
            0x11, 0xE0, 0x00, 0x02,
            0x02, 0x43, 0x88, 0x22,
            0x08, 0x00, 0x00, 0x07,
            0x02, 0x53, 0x88, 0x20,
            0xAD, 0x11, 0x00, 0x0C
        ])
    ]),

    procedure('sim_load_example_2', [
        'sim_reset',
        mem_load(INSTRUCTION_MEMORY, 0, '02X', [
            0xEB, 0xA0, 0x00, 0x04,
            0xEF, 0xB0, 0x00, 0x00
        ])
    ])
])

# Find vhdl files
vhd_file = re.compile(r'\w+\.vhd')

with open('support.tcl', 'w+') as support_file:
    #
    # Writing support file
    #

    # Compile procedure
    support_file.write('proc compile_all {} {\n')
    for filename in os.listdir():
        if vhd_file.match(filename):
            support_file.write('\tvcom -work work ' + filename + '\n')
    support_file.write('}\n\n')

    # Simulate procedure
    support_file.write(simulate)
