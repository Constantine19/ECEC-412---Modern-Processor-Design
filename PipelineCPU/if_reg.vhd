-- MIPS 32 CPU Pipeline Arch
-- Author:  Anshul Kharbanda
-- Created: 11 - 1 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity if_reg is
    port(
        CLK: in std_logic;
        pc_plus4_in: in std_logic_vector(31 downto 0);
        instruction_in: in std_logic_vector(31 downto 0);
        pc_plus4_out: out std_logic_vector(31 downto 0);
        instruction_out: out std_logic_vector(31 downto 0)
    );
end if_reg;

architecture arch of if_reg is
    component reg is
        generic (n: natural := 32);
        port(
            CLK: in std_logic;
            x: in std_logic_vector(n-1 downto 0);
            y: out std_logic_vector(n-1 downto 0)
        );
    end component;
begin
    pc_plus4_reg: reg
        generic map(32)
        port map(
            CLK=>CLK,
            x=>pc_plus4_in,
            y=>pc_plus4_out
        );
    instruction_reg: reg
        generic map(32)
        port map(
            CLK=>CLK,
            x=>instruction_in,
            y=>instruction_out
        );
end arch;
