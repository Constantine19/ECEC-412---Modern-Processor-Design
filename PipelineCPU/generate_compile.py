import os
import re

vhd_file = re.compile(r'\w+\.vhd')
with open('support.tcl', 'w+') as support_file:
    support_file.write('proc compile_all {} {\n')
    for filename in os.listdir():
        if vhd_file.match(filename):
            support_file.write('\tvcom -work work ' + filename + '\n')
    support_file.write('}')
