-- IF Stage
-- Author:  Anshul Kharbanda
-- Created: 11 - 29 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity if_stage is
    port (
        clk: in std_logic;
        jump_address: in std_logic_vector(31 downto 0);
        branch_address: in std_logic_vector(31 downto 0);
        jump, branch: in std_logic;
        predicted_address: out std_logic_vector(31 downto 0);
        fallback_address: out std_logic_vector(31 downto 0);
        instruction: out std_logic_vector(31 downto 0)
    );
end entity;

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
        jump_or_predicted,
        d_pc,
        pc,
        d_predicted_address,
        d_fallback_address,
        d_instruction:
    std_logic_vector(31 downto 0);
begin
    -- Compute next address
    jump_or_predicted <= jump_address when jump='1' else predicted_address;
    d_pc <= branch_address when branch='1' else jump_or_predicted;

    -- Program counter
    pc <= d_pc when rising_edge(clk) else pc;

    -- Instruction Memory
    instruction_memory: readonly_mem
        generic map(
            addr_size => 32,
            word_size => 4,
            data_size => 256
        )
        port map(
            addr => pc;
            data => d_instruction
        );
    instruction <= d_instruction when rising_edge(clk) else instruction;

    -- Branch Target Buffer Predictor
end architecture;
