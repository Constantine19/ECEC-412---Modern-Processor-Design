library ieee;
use ieee.std_logic_1164.all;
entity MUX32_4 is
port(w,v,x,y:in std_logic_vector (31 downto 0);
     sel:in std_logic_vector(1 downto 0);
     z:out std_logic_vector(31 downto 0));
end MUX32_4;
architecture behav of MUX32_4 is
begin
process(w,v,x,y,sel)
begin
if sel="00" then
z<=w;
elsif sel="01" then
z<=v;
elsif sel="10" then
z<=x;
elsif sel="11" then
z<=y;
end if;
end process;
end behav;