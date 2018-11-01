library ieee;
use ieee.std_logic_1164.all;

entity And2 is
port ( x : in std_logic;
       y : in std_logic;
       z : out std_logic);
end And2;

architecture behav of And2 is

begin

z <= x and y;

end behav;