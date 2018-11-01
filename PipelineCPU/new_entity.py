from sys import argv

template='''-- MIPS 32 CPU Pipeline Arch
-- Author:  Anshul Kharbanda
-- Created: 11 - 1 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity {name} is
    port(
        CLK: in std_logic;
{ports}
    );
end {name};

architecture arch of {name} is
    component reg is
        generic (n: natural := 32);
        port(
            CLK: in std_logic;
            x: in std_logic_vector(n-1 downto 0);
            y: out std_logic_vector(n-1 downto 0)
        );
    end component;
begin
    {maps}
end arch;
'''

port = '''      {name}_in: in std_logic_vector(31 downto 0);
        {name}_out: out std_logic_vector(31 downto 0);
'''

pmap = '''{name}_reg: reg
    generic map(32)
    port map(
        CLK=>CLK,
        x=>{name}_in,
        y=>{name}_out
    );
'''

name = '{}_reg'.format(argv[1])
signals = 

for name in names:
    print('Creating', name)
    with open(name+'.vhd', 'w+') as f:
        f.write(template.format(name=name))
