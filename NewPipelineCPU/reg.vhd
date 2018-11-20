-- Register components
-- Author:  Anshul Kharbanda
-- Created: 11/16/2018
---------------------------------- REG 1-Bit -----------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- 1-bit Register Entity
entity reg1 is
    port(
        clk, x: in std_logic;
        y: out std_logic
    );
end entity;

-- Architecture of 1-bit Register
architecture arch of reg1 is
    -- Internal memory signal
    signal mem: std_logic;
begin
    -- Store x in memory on clock
    store : process(clk)
    begin
        if clk'event and clk='1' then
            mem <= x;
        end if;
    end process;

    -- Output y from memory
    y <= mem;
end architecture;

---------------------------------- REG N-Bit -----------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Generic N-bit Register
entity reg is
    generic (
        n: natural := 32
    );
    port(
        clk: in std_logic;
        x: in std_logic_vector(n-1 downto 0);
        y: out std_logic_vector(n-1 downto 0)
    );
end entity;

-- Architecture of N-bit register
architecture arch of reg is
    -- Uses 1-bit register
    component reg1 is
        port (
            clk, x: in std_logic;
            y: out std_logic);
    end component;
begin
    -- Generate registers
    gen_regs : for i in n-1 downto 0 generate
        regmap : reg1 port map(clk, x(i), y(i));
    end generate;
end architecture;
