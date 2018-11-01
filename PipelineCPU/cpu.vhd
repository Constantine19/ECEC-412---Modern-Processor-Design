-- MIPS 32 CPU Pipeline Arch
-- Author:  Anshul Kharbanda
-- Created: 11 - 1 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity cpu is
    port(
CLK: in std_logic
    );
end cpu;

architecture arch of cpu is
    -- Components
    component mux is
        generic(n: natural := 32);
        port(
            x0,x1: in std_logic_vector(n-1 downto 0);
            sel: in std_logic;
            z: out std_logic_vector(n-1 downto 0)
        );
    end component;
    component reg is
        generic (n: natural := 32);
        port(
            CLK: in std_logic;
            x: in std_logic_vector(n-1 downto 0);
            write: in std_logic;
            y: out std_logic_vector(n-1 downto 0)
        );
    end component;

begin

-- IF

-- program counter
-- instruction fetch
-- pc + 4

-- ID

-- jump address
-- controller
-- Mux dest register
-- registers
-- sign extend

-- EX

-- ALU
-- Branch and
-- Branch address
-- Mux branch
-- Mux jump

-- MEM

-- memory

-- WB

-- select

end arch;
