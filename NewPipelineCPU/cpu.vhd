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
    -- Declare stage components
    component pc_stage
        port (
            clk               : in std_logic;
            branch_address    : in std_logic_vector(31 downto 0);
            branch_command    : in std_logic;
            pc                : buffer std_logic_vector(31 downto 0);
            predicted_address : buffer std_logic_vector(31 downto 0);
            fallback_address  : out std_logic_vector(31 downto 0)
        );
    end component pc_stage;
    component if_stage
        port (
            clk                   : in  std_logic;
            pc                    : in  std_logic_vector(31 downto 0);
            predicted_address_in  : in  std_logic_vector(31 downto 0);
            fallback_address_in   : in  std_logic_vector(31 downto 0);
            branch                : in  std_logic;
            instruction           : out std_logic_vector(31 downto 0);
            predicted_address_out : out std_logic_vector(31 downto 0);
            fallback_address_out  : out std_logic_vector(31 downto 0)
        );
    end component if_stage;

    -- Declare Signals
    signal
        PC_branch_address,
        PC_pc,
        PC_predicted_address,
        PC_fallback_address,
        IF_instruction,
        IF_predicted_address,
        IF_fallback_address
    : std_logic_vector(31 downto 0);
    signal
        PC_branch,
        IF_branch
    : std_logic;
begin
    -- PC Stage
        -- Program Counter
        -- Branch Address Buffer
    pc_stage_i : pc_stage
        port map (
            clk               => clk,
            branch_address    => PC_branch_address,
            branch_command    => PC_branch,
            pc                => PC_pc,
            predicted_address => PC_predicted_address,
            fallback_address  => PC_fallback_address
        );


    -- IF STAGE
        -- Fetch Instruction
    if_stage_i : if_stage
        port map (
            clk                   => clk,
            pc                    => PC_pc,
            predicted_address_in  => PC_predicted_address,
            fallback_address_in   => PC_fallback_address,
            branch                => IF_branch,
            instruction           => IF_instruction,
            predicted_address_out => IF_predicted_address,
            fallback_address_out  => IF_fallback_address
        );


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

end architecture;
