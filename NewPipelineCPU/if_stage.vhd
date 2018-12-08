-- IF Stage
-- Author:  Anshul Kharbanda
-- Created: 11 - 29 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity if stage
entity if_stage is
    port (
        clk: in std_logic;
        pc_in: in std_logic_vector(31 downto 0);
        predicted_address_in: in std_logic_vector(31 downto 0);
        fallback_address_in: in std_logic_vector(31 downto 0);
        branch: in std_logic;
        pc_out: out std_logic_vector(31 downto 0);
        instruction: out std_logic_vector(31 downto 0);
        predicted_address_out: out std_logic_vector(31 downto 0);
        fallback_address_out: out std_logic_vector(31 downto 0)
    );
end entity;

-- Architecture of if stage
architecture arch of if_stage is
    -- Read only memory entity
    component readonly_mem is
        generic(
            addr_size : natural := 32; -- Address size in bits
            word_size : natural := 4;  -- Word size in bytes
            data_size : natural := 256 -- Data size in bytes
        );
        port(
            addr : in std_logic_vector(addr_size-1 downto 0);   -- Input address
            data : out std_logic_vector(8*word_size-1 downto 0) -- Output data
        );
    end component;

    -- Declare signals
    signal
        pre_stall_instruction,
        d_instruction,
        q_instruction,
        q_pc,
        q_predicted_address,
        q_fallback_address
    : std_logic_vector(31 downto 0);

    -- Declare constants
    constant
        undef
    : std_logic_vector(31 downto 0)
    := (others => 'X');
begin
    -- Instruction Memory
    instruction_memory: readonly_mem
        generic map(
            addr_size => 32,
            word_size => 4,
            data_size => 256
        )
        port map(
            addr => pc_in,
            data => pre_stall_instruction
        );

    -- Handle stall
    d_instruction <= undef when branch='1' else pre_stall_instruction;

    -- Commit values
    q_pc <= pc_in when clk'event and clk='1' else q_pc;
    q_instruction <= d_instruction when clk'event and clk='1' else q_instruction;
    q_predicted_address <= predicted_address_in when clk'event and clk='1' else q_predicted_address;
    q_fallback_address <= fallback_address_in when clk'event and clk='1' else q_fallback_address;

    -- Output
    pc_out <= q_pc;
    instruction <= q_instruction;
    predicted_address_out <= q_predicted_address;
    fallback_address_out <= q_fallback_address;
end architecture;
