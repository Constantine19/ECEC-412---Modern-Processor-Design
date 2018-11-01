library ieee;
use ieee.std_logic_1164.all;

entity NOR32 is
port (x : in std_logic_vector(31 downto 0);
      y : out std_logic);
end NOR32;

architecture behav of NOR32 is

begin

process(x)

begin

if x = "00000000000000000000000000000000" then
	y <= '1';
else
	y <= '0';
end if;
end process;
end behav;
