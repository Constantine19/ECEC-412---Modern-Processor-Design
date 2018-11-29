-- Mux Component
-- Author:  Anshul Kharbanda
-- Created: 11 - 27 - 2018
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
---------------------------------- MUX 1-sel -----------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Mux entity
entity mux is
    generic(
        width: natural := 32
    );
    port(
        x, y: in std_logic_vector(width-1 downto 0);
        sel: in std_logic;
        z: out std_logic_vector(width-1 downto 0)
    );
end entity;

-- Mux architecture
architecture arch of mux is
begin
    z <= y when sel='1' else x;
end architecture;
