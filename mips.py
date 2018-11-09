def rtype(opcode, rs, rt, rd, shamt, funct):
    instruction = opcode << 26 \
                | rs << 21 \
                | rt << 16 \
                | rd << 11 \
                | shamt << 6 \
                | funct
    bytemax = 256
    bytes = [instruction // bytemax**i % bytemax for i in range(3,-1,-1)]
    return [format(byte, '02X') for byte in bytes]
