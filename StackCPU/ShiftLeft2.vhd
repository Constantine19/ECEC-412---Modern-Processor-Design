library IEEE;
use ieee.std_logic_1164.all;

entity ShiftLeft2 is
port(x:in std_logic_vector(31 downto 0);
	y:out std_logic_vector(31 downto 0));
end ShiftLeft2;

architecture behavioral of ShiftLeft2 is
begin
process(x)
begin
y<=x(29 downto 0)&"00";
end process;
end behavioral;

