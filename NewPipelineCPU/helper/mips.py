"""
Generates mips bytecode from assembler

Author:  Anshul Kharbanda
Created: 12 - 7 - 2018
"""
from sys import argv
from functools import reduce
from re import compile

# ------------------------------ REGISTER HELPER -------------------------------

# Register regular expression
register_regex = compile(r'\$([a-z]+)([0-9]+)?')

# Register table
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

def register_lookup(name):
    """
    Returns integer register code for given register name

    :param name: register name

    :return: integer register code for given register name
    """
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

# ----------------------------- INSTRUCTION HELPER -----------------------------

def bytearray_from_integer(integer):
    """
    Takes an integer and returns a 4-byte array

    :param integer: integer to process

    :return: bytearray converted from integer
    """
    bytemax = 256
    return [
        format(integer // bytemax**i % bytemax, '02X')
        for i in range(3,-1,-1)
    ]

def create_instruction(arguments):
    """
    Creates an integer instruction by concatenating the
    given arguments with their respective shifts

    :param arguments: the input arguments to concat and
                      their respective shift position
                      to insert at
    """
    masks = [argument << shift for argument, shift in arguments]
    return reduce(lambda integer, mask: integer | mask, masks)

# ----------------------------- INSTRUCTION TYPES ------------------------------

def rtype(opcode, rs, rt, rd, shamt, funct):
    """
    Creates an r-type instruction from the given arguments

    :param opcode: operation code of instruction
    :param rs:     rs register code
    :param rt:     rt register code
    :param rd:     rd register code
    :param shamt:  shift amount code
    :param funct:  alu funct code

    :return: r-type instruction
    """
    instruction = create_instruction(
        [ (opcode, 26),
          (rs,     21),
          (rt,     16),
          (rd,     11),
          (shamt,   6),
          (funct,   0) ]
    )
    return bytearray_from_integer(instruction)

def itype(opcode, rs, rt, imm):
    """
    Creates an i-type instruction from the given arguments

    :param opcode: operation code of instruction
    :param rs:     rs register code
    :param rt:     rt register code
    :param imm:    immediate value

    :return: i-type instruction
    """
    instruction = create_instruction(
        [ (opcode, 26),
          (rs,     21),
          (rt,     16),
          (imm,     0) ]
    )
    return bytearray_from_integer(instruction)

def jtype(opcode, address):
    """
    Creates a j-type instruction from the given arguments

    :param opcode:   operation code of instruction
    :param addresss: jump address of instruction

    :return: j-type instruction
    """
    instruction = create_instruction(
        [ (opcode,  26),
          (address,  0) ]
    )
    return bytearray_from_integer(instruction)

# ----------------------------- INSTRUCTION CODES ------------------------------

# Operation table
opcode_table = {
    'alu'  : 0x00,
    'addi' : 0x08,
    'lw'   : 0x23,
    'sw'   : 0x2B,
    'j'    : 0x02,
    'beq'  : 0x04,
    'bne'  : 0x05
}

# Funct table
funct_table = {
    'add' : 0x20,
    'and' : 0x24,
    'or'  : 0x25,
    'nor' : 0x27,
    'slt' : 0x0A
}

# ---------------------------- PROCESS INSTRUCTION -----------------------------

def process_instruction(line):
    """
    Prints byte array parsed from instruction string

    :param line: instruction line to parse
    """
    # Parse tokens and get operation
    instruction = line.rstrip(' \r\n')
    tokens = instruction.split(' ')
    operation = tokens[0]

    # Select type of instruction
    if operation in funct_table:
        # R-type instruction
        funct = funct_table[operation]
        opcode = opcode_table['alu']
        rd,rs,rt = map(register_lookup, tokens[1:4])
        shamt = 0
        instruction_bytes = rtype(opcode, rs, rt, rd, shamt, funct)
    elif operation == 'j':
        # J-type instruction
        opcode = opcode_table['j']
        address = int(tokens[1])
        instruction_bytes = jtype(opcode, address)
    else:
        # I-type instruction
        opcode = opcode_table[operation]
        rt,rs = map(register_lookup, tokens[1:3])
        imm = int(tokens[3])
        instruction_bytes = itype(opcode, rs, rt, imm)

    # Print instruction
    print(*instruction_bytes)

# ------------------------------------ MAIN ------------------------------------

def main(argv):
    """
    Main code

    :param argv: command line arguments
    """
    # If filename is given
    if len(argv) > 1:
        # Process instructions from file
        with open(argv[1], 'r') as asm_file:
            for instruction in asm_file:
                process_instruction(instruction)
    else:
        # Print message
        print('Please specify a file!')
if __name__ == '__main__':
    main(argv)
