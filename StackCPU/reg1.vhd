-- MIPS 32 CPU Pipeline Arch
-- Author:  Anshul Kharbanda
-- Created: 11 - 1 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity reg1 is
    port(
        clk: in std_logic;
        x: in std_logic;
        y: out std_logic
    );
end reg1;

architecture arch of reg1 is
    signal m: std_logic;
begin
    -- Wire x to m on clock
    process(clk)
    begin
        if clk'event and clk='1' then
            m <= x;
        end if;
    end process;

    -- Wire y to m
    y <= m;
end arch;
