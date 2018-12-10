-- EX Stage
-- Author:  Anshul Kharbanda
-- Created: 11 - 29 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- EX Stage Entity
entity ex_stage is
    port (
        clk: in std_logic;

        -- Branch handling
        pc: in std_logic_vector(31 downto 0);
        predicted_address: in std_logic_vector(31 downto 0);
        fallback_address: in std_logic_vector(31 downto 0);

        -- Signals
        ID_aluop: in std_logic_vector(2 downto 0);
        ID_alusrc, ID_branch,
        ID_memwrite, ID_mem2reg,
        ID_regwrite,
        ID_stackop, ID_stackpushpop: in std_logic;

        -- Data
        ID_read_data_1, ID_read_data_2: in std_logic_vector(31 downto 0);
        ID_read_address_1, ID_read_address_2: in std_logic_vector(4 downto 0);
        ID_se_immediate: in std_logic_vector(31 downto 0);
        ID_funct: in std_logic_vector(5 downto 0);
        ID_write_address: in std_logic_vector(4 downto 0);
        EX_write_address_in: in std_logic_vector(4 downto 0);
        MEM_write_address: in std_logic_vector(4 downto 0);
        EX_write_data_in: in std_logic_vector(31 downto 0);
        MEM_write_data: in std_logic_vector(31 downto 0);

        -- Branch handling out
        branch_execute : out std_logic;
        branch_address : out std_logic_vector(31 downto 0);

        -- Output signals
        EX_memwrite, EX_mem2reg,
        EX_regwrite: in std_logic;

        -- Output data
        EX_alu_result: out std_logic_vector(31 downto 0);
        EX_write_data_out: out std_logic_vector(31 downto 0);
        EX_write_address_out: out std_logic_vector(4 downto 0)
    );
end entity;

-- EX Stage Architecture
architecture arch of ex_stage is
    signal
        stack_push_pop_result
    : std_logic_vector(31 downto 0);

    constant four : std_logic_vector(31 downto 0)
    := (2=>'1', others=>'0');
    constant neg_four : std_logic_vector(31 downto 0)
    := (1=>'0', 0=>'0', others=>'1');
begin
    -- Compute Operands
        -- SignExtend/Register2/Stack Push/Stack Pop
        stack_push_pop_result <= four when ID_stackpushpop='1' else neg_four;
        -- Forwarding Units

    -- ALU
        -- ALU Control
        -- ALU Src

    -- Branch
        -- Handle branch

    -- Forwarding
        -- Forwarding unit
end architecture;
