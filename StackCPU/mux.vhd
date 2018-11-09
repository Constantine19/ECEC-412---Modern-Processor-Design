-- MIPS 32 CPU Pipeline Arch
-- Author:  Anshul Kharbanda
-- Created: 11 - 1 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity mux is
    generic (n: natural := 32);
    port (
        x: in std_logic_vector(n-1 downto 0);
        y: in std_logic_vector(n-1 downto 0);
        sel: in std_logic;
        z: out std_logic_vector(n-1 downto 0)
    );
end mux;

architecture arch of mux is
begin
    process(x, y, sel)
    begin
        case(sel) is
            when '0' => z <= x;
            when others => z <= y;
        end case;
    end process;
end arch;
