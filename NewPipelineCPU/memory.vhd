-- Memory components
-- Author:  Anshul Kharbanda
-- Created: 11 - 19 - 2018
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
------------------------------- READONLY MEMORY --------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Read only memory entity
entity readonly_mem is
    generic(
        addr_size : natural := 32; -- Address size in bits
        word_size : natural := 4;  -- Word size in bytes
        data_size : natural := 256 -- Data size in bytes
    );
    port(
        addr : in std_logic_vector(addr_size-1 downto 0);   -- Input address
        data : out std_logic_vector(8*word_size-1 downto 0) -- Output data
    );
end entity;

-- Read only memory architecture
architecture arch of readonly_mem is
    -- Memory array
    type memory_array is
        array (0 to data_size-1)
        of std_logic_vector(7 downto 0);
    signal memory : memory_array;
begin
    -- Read data process
    read_data : process(addr)
        variable int_addr : integer;
    begin
        -- Integer addr
        int_addr := to_integer(unsigned(addr));

        -- Read bytes
        read_bytes : for i in 0 to word_size-1 loop
            data(8*i+7 downto 8*i) <= memory(int_addr + word_size - i - 1);
        end loop;
    end process;
end architecture;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
------------------------------- WRITABLE MEMORY --------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Writable memory entity
entity writable_mem is
    generic(
        addr_size : natural := 32; -- Address size in bits
        word_size : natural := 4;  -- Word size in bytes
        data_size : natural := 256 -- Data size in bytes
    );
    port(
        clk : in std_logic;
        addr : in std_logic_vector(addr_size-1 downto 0);
        wdata : in std_logic_vector(8*word_size-1 downto 0);
        write : in std_logic;
        rdata : out std_logic_vector(8*word_size-1 downto 0)
    );
end entity;

-- Writable memory architecture
architecture arch of writable_mem is
    -- Memory array
    type memory_array is
        array (0 to data_size-1)
        of std_logic_vector(7 downto 0);
    signal memory : memory_array;
begin
    -- Write data process
    write_data : process(clk)
        variable int_addr : integer;
    begin
        -- Integer addr
        int_addr := to_integer(unsigned(addr));

        -- Write bytes on write enable and clock
        on_write_enable_clock : if clk'event and clk='1' and write='1' then
            write_bytes : for i in 0 to word_size-1 loop
                memory(int_addr + word_size-i-1) <= wdata(8*i+7 downto 8*i);
            end loop;
        end if;
    end process;

    -- Read data process
    read_data : process(clk, addr)
        variable int_addr : integer;
    begin
        -- Integer addr
        int_addr := to_integer(unsigned(addr));

        -- Read bytes
        read_bytes : for i in 0 to word_size-1 loop
            rdata(8*i+7 downto 8*i) <= memory(int_addr + word_size-i-1);
        end loop;
    end process;
end architecture;
