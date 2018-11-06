-- MIPS 32 CPU Stack Arch
-- Author:  Anshul Kharbanda
-- Created: 11 - 1 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity reg is
    generic (n: natural := 32);
    port(
        clk: in std_logic;
        x: in std_logic_vector(n-1 downto 0);
        y: out std_logic_vector(n-1 downto 0)
    );
end reg;

architecture arch of reg is
    component reg1 is
        port(
            clk: in std_logic;
            x: in std_logic;
            y: out std_logic
        );
    end component;
begin
    regs: for i in 0 to n-1 generate
        regi: reg1 port map(clk, x(i), y(i));
    end generate;
end arch;
