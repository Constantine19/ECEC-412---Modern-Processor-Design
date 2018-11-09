from functools import reduce
from re import compile

register_regex = compile(r'\$([a-z]+)([0-9]+)?')

register_table = {
    'zero': 0,
    'at': 1,
    'v': list(range(2,4)),
    'a': list(range(4,8)),
    't': list(range(8,16)) + list(range(24,26)),
    's': list(range(16,24)),
    'k': list(range(26,28)),
    'gp': 28,
    'sp': 29,
    'fp': 30,
    'ra': 31
}

opcode_table = {
    'alu': 0x00,
    'lw': 0x23,
    'sw': 0x2b
}

funct_table = {
    'add': 0x20
}

def register_lookup(name):
    match = register_regex.match(name)
    if match:
        register = register_table[match.group(1)]
        if match.group(2):
            try:
                register = register[int(match.group(2))]
            except Exception as e:
                raise Exception('Register name invalid %s' % name)
        return register
    else:
        raise Exception('Register name invalid %s' % name)

def bytearray(integer):
    bytemax = 256
    bytes = [integer // bytemax**i % bytemax for i in range(3,-1,-1)]
    return [format(byte, '02X') for byte in bytes]

def create_instruction(arguments, shifts):
    masks = [argument << shift for argument, shift in zip(arguments, shifts)]
    return reduce(lambda a, b: a | b, masks)

def rtype(opcode, rs, rt, rd, shamt, funct):
    instruction = create_instruction(
        [opcode, rs, rt, rd, shamt, funct],
        [    26, 21, 16, 11,     6,     0]
    )
    return bytearray(instruction)

def itype(opcode, rs, rt, imm):
    instruction = create_instruction(
        [opcode, rs, rt, imm],
        [    26, 21, 16,   0]
    )
    return bytearray(instruction)

def jtype(opcode, address):
    instruction = create_instruction(
        [opcode, address],
        [    26,       0]
    )
    return bytearray(instruction)

ALU = 0x00
LW = 0x23
SW = 0x2B
