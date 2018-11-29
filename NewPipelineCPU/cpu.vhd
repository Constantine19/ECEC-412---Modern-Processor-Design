-- Main CPU Component
-- Author:  Anshul Kharbanda
-- Created: 11 - 29 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- CPU Entity
entity cpu is
    port(clk: in std_logic);
end entity;

architecture arch of cpu is
    -- Declare subtypes
    subtype byte is std_logic_vector(7 downto 0);
    subtype word is std_logic_vector(31 downto 0);
    subtype reg_address is std_logic_vector(4 downto 0);

    -- Declare components
    component register_table is
        generic(
            addr_size :  natural := 5;
            value_size : natural := 32;
            table_size : natural := 32
        );
        port(
            clk: in std_logic;
            raddr1, raddr2, waddr: in std_logic_vector(addr_size-1 downto 0);
            wvalue: in std_logic_vector(value_size-1 downto 0);
            write, stackop: in std_logic;
            rvalue1, rvalue2: out std_logic_vector(value_size-1 downto 0)
        );
    end component;
    component writable_mem is
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
    end component;

    -- Signals
    signal
        ID_read_address_1,
        ID_read_address_2,
        WB_write_address
    : reg_address;
    signal
        ID_read_value_1,
        ID_read_value_2,
        MEM_address,
        MEM_write_data,
        MEM_read_data,
        WB_write_value
    : word;
    signal
        stackop,
        MEM_write,
        WB_write
    : std_logic;
begin
    -- Register Table
    register_table_map: register_table
        generic map(
            addr_size => 5,
            value_size => 32,
            table_size => 32
        )
        port map(
            clk => clk,
            raddr1 => ID_read_address_1,
            raddr2 => ID_read_address_2,
            waddr => WB_write_address,
            wvalue => WB_write_value,
            write => WB_write,
            stackop => stackop,
            rvalue1 => ID_read_value_1,
            rvalue2 => ID_read_value_2
        );

    -- Memory Store
    memory_store: writable_mem
        generic map(
            addr_size => 32,
            word_size => 4,
            data_size => 256
        )
        port map(
            clk => clk,
            addr => MEM_address,
            wdata => MEM_write_data,
            write => MEM_write,
            rdata => MEM_read_data
        );

    -- IF STAGE
        -- Program Counter
        -- Branch Address Buffer
        -- Fetch Instruction

    -- ID STAGE
        -- Jump
        -- Control
        -- Read Register
        -- Sign Extend
        -- Write Address

    -- EX STAGE
        -- Compute Operands
            -- SignExtend/Register2/Stack Push/Stack Pop
            -- Forwarding Units
            -- Stack Op
            -- Stack Push Pop
        -- ALU Operation
        -- Branch

    -- MEM STAGE
        -- Handle Memory

    -- WB STAGE
        -- Write Register

end architecture;
