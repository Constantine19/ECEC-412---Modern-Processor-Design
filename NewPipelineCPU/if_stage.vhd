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
        jump_address: in std_logic_vector(31 downto 0);
        branch_address: in std_logic_vector(31 downto 0);
        fallback_address_in: in std_logic_vector(31 downto 0);
        jump, branch, fallback: in std_logic;
        predicted_address: buffer std_logic_vector(31 downto 0);
        fallback_address_out: buffer std_logic_vector(31 downto 0);
        instruction: out std_logic_vector(31 downto 0)
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
    component btb_predictor is
        generic (
            n : natural := 32
        );
        port (
            clk: in std_logic;
            pc, next_address: in std_logic_vector(n-1 downto 0);
            branch: in std_logic;
            predicted_address,
            fallback_address: out std_logic_vector(n-1 downto 0)
        );
    end component;

    -- Declare signals
    signal
        branch_command,
        stall,
        delayed_clk:
    std_logic;
    signal
        check_jump,
        check_branch,
        pre_stall_instruction,
        d_pc,
        q_pc:
    std_logic_vector(31 downto 0);

    -- Declare constants
    constant
        zero
    : std_logic_vector(31 downto 0)
    := (others => '0');
begin
    -- Delayed clock
    delayed_clk <= clk after 1 ns;

    -- Compute next pc
    check_jump <= jump_address when jump='1' else predicted_address;
    check_branch <= branch_address when branch='1' else check_jump;
    d_pc <= fallback_address_in when fallback='1' else check_branch;

    -- Set branch command
    branch_command <= jump or branch;

    -- Set stall command
    stall <= jump or branch or fallback;

    -- Branch Target Buffer Predictor
    branch_target_buffer: btb_predictor
        generic map(
            n => 32
        )
        port map(
            clk => clk,
            pc => q_pc,
            next_address => d_pc,
            branch => branch_command,
            predicted_address => predicted_address,
            fallback_address => fallback_address_out
        );

    -- Program counter
    q_pc <= d_pc when delayed_clk'event and delayed_clk='1' else q_pc;

    -- Instruction Memory
    instruction_memory: readonly_mem
        generic map(
            addr_size => 32,
            word_size => 4,
            data_size => 256
        )
        port map(
            addr => q_pc,
            data => pre_stall_instruction
        );

    -- Handle stall
    instruction <= zero when stall='1' else pre_stall_instruction;
end architecture;
