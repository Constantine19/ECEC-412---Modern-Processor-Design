from sys import argv

template='''-- MIPS 32 CPU Pipeline Arch
-- Author:  Anshul Kharbanda
-- Created: 11 - 1 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity {name} is
    port(

    );
end {name};

architecture arch of {name} is
begin

end arch;
'''

names = argv[1:]
for name in names:
    print('Creating', name)
    with open(name+'.vhd', 'w+') as f:
        f.write(template.format(name=name))
