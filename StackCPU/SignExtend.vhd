library IEEE;
use ieee.std_logic_1164.all;

entity SignExtend is
port(x:in std_logic_vector(15 downto 0);
	y:out std_logic_vector(31 downto 0));
end SignExtend;

architecture behavioral of SignExtend is
begin
process(x)
begin
if x(15)='1' then
y<="1111111111111111"&x;
else
y<="0000000000000000"&x;
end if;
end process;
end behavioral;

