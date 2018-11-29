-- Main CPU Component
-- Author:  Anshul Kharbanda
-- Created: 11 - 29 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- CPU Entity
entity cpu is
    port(
        clk: in std_logic
    );
end entity;

architecture arch of cpu is
begin
    -- Register Table
    -- Memory Store

    -- IF STAGE
        -- Program Counter
        -- Branch Address Buffer

    -- ID STAGE
        -- Jump
        -- Control
        -- Read Register
        -- Sign Extend
        -- Write Address

    -- EX STAGE
        -- Compute Operands
        -- ALU Operation
        -- Branch

    -- MEM STAGE
        -- Memory

    -- WB STAGE
        -- Write Register

end architecture;
