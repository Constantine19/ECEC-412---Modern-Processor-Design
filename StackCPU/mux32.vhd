library ieee;
use ieee.std_logic_1164.all;

entity mux32 is
port(x, y : in std_logic_vector(31 downto 0);
	z : out std_logic_vector(31 downto 0);
      sel : in std_logic);
end mux32;

architecture behav of mux32 is

begin

process(x,y,sel)

begin

if sel='0' then
	z <= x;
elsif sel ='1' then
	z <= y;
end if;
end process;
end behav;
