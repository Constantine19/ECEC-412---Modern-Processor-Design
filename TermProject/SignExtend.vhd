library ieee;
use ieee.std_logic_1164.all;
entity SignExtend is
port(x:in std_logic_vector(15 downto 0);y:out std_logic_vector(31 downto 0));
end SignExtend;
architecture behav of SignExtend is
begin
process(x)
variable temp:std_logic_vector(31 downto 0);
begin
temp(15 downto 0):=x(15 downto 0);
temp(31 downto 16):=(others=>x(15));
y<=temp;
end process;
end behav;