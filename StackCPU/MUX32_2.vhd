library ieee;
use ieee.std_logic_1164.all;
entity MUX32_2 is
port(x,y:in std_logic_vector (31 downto 0);
     sel:in std_logic_vector(1 downto 0);
     z:out std_logic_vector(31 downto 0));
end MUX32_2;
architecture behav of MUX32_2 is
begin
process(x,y,sel)
begin
if sel="00" then
z<=x;
elsif sel="01" then
z<=x;
elsif sel="10" then
z<=y;
elsif sel="11" then
z<=x;
end if;
end process;
end behav;