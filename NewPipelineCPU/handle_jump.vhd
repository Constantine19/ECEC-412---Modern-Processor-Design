-- ID Stage
-- Author:  Anshul Kharbanda
-- Created: 11 - 29 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Handle jump entity
entity handle_jump is
    port (
        predicted_address: in std_logic_vector(31 downto 0);
        pc: in std_logic_vector(31 downto 0);
        jump_code: in std_logic_vector(25 downto 0);
        jump: in std_logic;
        jump_address: out std_logic_vector(31 downto 0);
        jump_execute: out std_logic
    );
end entity;

-- Handle jump architecture
architecture arch of handle_jump is
    signal full_jump_address: std_logic_vector(31 downto 0);
    signal not_equal: std_logic;
begin
    -- Create jump address
    full_jump_address <= pc(31 downto 28) & jump_code & "00";
    jump_address <= full_jump_address;

    -- Calculate not equal
    not_equal <= '0' when full_jump_address = predicted_address else '1';

    -- Execute jump if jump and full_jump_address is not equal to predicted_address
    jump_execute <= jump and not_equal;
end architecture;
