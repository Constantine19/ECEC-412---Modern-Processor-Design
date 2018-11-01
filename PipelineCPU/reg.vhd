-- MIPS 32 CPU Pipeline Arch
-- Author:  Anshul Kharbanda
-- Created: 11 - 1 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity reg is
    generic (n: natural := 32);
    port(
        CLK: in std_logic;
        x: in std_logic_vector(n-1 downto 0);
        write: in std_logic;
        y: out std_logic_vector(n-1 downto 0)
    );
end reg;

architecture arch of reg is
    signal mem: std_logic_vector(n-1 downto 0);
begin
    -- Set mem to x if write enable and clock rising edge event
    process(CLK)
    begin
        if CLK'event and CLK='1' and write='1' then
            mem <= x;
        end if;
    end process;

    -- Output memory
    y <= mem;
end arch;
