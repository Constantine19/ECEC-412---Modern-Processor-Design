library ieee;
use ieee.std_logic_1164.all;
entity PC is
port(clk:in std_logic;
     AddressIn:in std_logic_vector(31 downto 0);
     AddressOut:out std_logic_vector(31 downto 0));
end PC;
architecture behav of PC is
begin
process(clk)
  variable temp:std_logic_vector(31 downto 0);
  variable count:integer:=0;
begin
  if count=0 then
    temp:=(others=>'0');
  else
    temp:=AddressIn;
  end if;
if clk='1' and clk'event then
AddressOut<=temp;
count:=count+1;
end if;
end process;
end behav;
