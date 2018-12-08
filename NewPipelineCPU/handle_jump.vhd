-- ID Stage
-- Author:  Anshul Kharbanda
-- Created: 11 - 29 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity handle_jump is
    port (
        predicted_address: in std_logic_vector(31 downto 0);
        pc: in std_logic_vector(31 downto 0);
        jump_address: in std_logic_vector(31 downto 0);
        jump: in std_logic
    );
end entity;

architecture arch of handle_jump is
begin



end architecture;
