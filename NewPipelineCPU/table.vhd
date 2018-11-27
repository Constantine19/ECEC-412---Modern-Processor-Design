-- Table Component
-- Author:  Anshul Kharbanda
-- Created: 11 - 26 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Table entity
entity table is
    generic(
        addr_size: natural := 32;
        value_size: natural := 32;
        table_size: natural := 32
    );
    port(
        clk: in std_logic;
        addr: in std_logic_vector(addr_size-1 downto 0);
        wvalue: in std_logic_vector(value_size-1 downto 0);
        write: in std_logic;
        rvalue: out std_logic_vector(value_size-1 downto 0)
    );
end entity;

-- Table architecture
architecture arch of table is
    -- Declare table array
    type table_array is
        array (0 to table_size-1)
        of std_logic_vector(value_size-1 downto 0);
    signal table: table_array;
begin
    -- Write table process
    write_value: process(clk)
        variable int_addr: integer;
    begin
        -- Convert to integer address
        int_addr := to_integer(unsigned(addr));

        -- Write value on clock
        write_on_clock_enable: if clk'event and clk='1' and write='1' then
            table(int_addr) <= wvalue;
        end if;
    end process;

    -- Read table process
    read_value: process(clk, addr)
        variable int_addr: integer;
    begin
        -- Convert to integer address
        int_addr := to_integer(unsigned(addr));

        -- Read value
        rvalue <= table(int_addr);
    end process;
end architecture;
