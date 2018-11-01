library ieee;
use ieee.std_logic_1164.all;

entity ShiftLeft2Jump is
port( x : in std_logic_vector(3 downto 0);
      y : in std_logic_vector(25 downto 0);
      z : out std_logic_vector(31 downto 0));
end ShiftLeft2Jump;

architecture behav of ShiftLeft2Jump is

begin

process(x,y)
variable temp : std_logic_vector(31 downto 0);

begin

temp := x&y&"00";
z <= temp;

end process;
end behav;