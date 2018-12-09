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

    function not_equal(a,b: std_logic_vector) return std_logic is
    begin
        if a = b then return '0';
        else return '1';
        end if;
    end not_equal;

begin
    -- Create jump address
    full_jump_address <= pc(31 downto 28) & jump_code & "00";
    jump_address <= full_jump_address;

    -- Execute jump if jump and full_jump_address is not equal to predicted_address
    jump_execute <= jump and not_equal(full_jump_address, predicted_address);
end architecture;
