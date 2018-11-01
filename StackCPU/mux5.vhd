library ieee;
use ieee.std_logic_1164.all;

entity mux5 is
port(x, y : in std_logic_vector(4 downto 0);
	z : out std_logic_vector(4 downto 0);
      sel : in std_logic);
end mux5;

architecture behav of mux5 is

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