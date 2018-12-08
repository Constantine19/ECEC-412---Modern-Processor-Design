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
        jump_code: in std_logic_vector(25 downto 0);
        jump: in std_logic;
        jump_address: out std_logic_vector(31 downto 0);
        jump_execute: out std_logic
    );
end entity;

architecture arch of handle_jump is
    signal full_jump_address, check_equal: std_logic_vector(31 downto 0);
    signal sum_equal: std_logic;
begin
    -- Create jump address
    full_jump_address <= pc(31 downto 28) & jump_code & "00";
    jump_address <= full_jump_address;

    -- Check equal
    check_equal <= full_jump_address xnor predicted_address;
    sum_equal_p : process(check_equal)
        variable reduce_equal: std_logic := '1';
    begin
        identifier : for i in 1 to 31 loop
            sum_equal <= check_equal(i-1) and check_equal(i);
        end loop;
    end process;

    -- Execute jump if jump and full_jump_address is not equal to predicted_address
    jump_execute <= jump and sum_equal;
end architecture;
