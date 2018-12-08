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
            pc_in                 : in  std_logic_vector(31 downto 0);
            predicted_address_in  : in  std_logic_vector(31 downto 0);
            fallback_address_in   : in  std_logic_vector(31 downto 0);
            branch                : in  std_logic;
            pc_out                : out std_logic_vector(31 downto 0);
            instruction           : out std_logic_vector(31 downto 0);
            predicted_address_out : out std_logic_vector(31 downto 0);
            fallback_address_out  : out std_logic_vector(31 downto 0)
        );
    end component if_stage;
    component id_stage
        port (
            clk                   : in  std_logic;
            branch_execute        : in  std_logic;

            -- Previous stage input
            pc_in                 : in  std_logic_vector(31 downto 0);
            predicted_address_in  : in  std_logic_vector(31 downto 0);
            fallback_address_in   : in  std_logic_vector(31 downto 0);
            instruction           : in  std_logic_vector(31 downto 0);

            -- WB Data
            WB_result             : in  std_logic_vector(31 downto 0);
            WB_write_address      : in  std_logic_vector(4 downto 0);
            WB_regwrite           : in  std_logic;

            -- Jump
            jump_address          : out std_logic_vector(31 downto 0);
            jump_execute          : out std_logic;

            -- Addresses
            pc_out                : out std_logic_vector(31 downto 0);
            predicted_address_out : out std_logic_vector(31 downto 0);
            fallback_address_out  : out std_logic_vector(31 downto 0);

            -- Signals
            ID_aluop              : out std_logic_vector(2 downto 0);
            ID_alusrc, ID_branch,
            ID_memwrite, ID_memread, ID_mem2reg,
            ID_regwrite,
            ID_stackop,
            ID_stackpushpop       : out std_logic;

            -- EX data
            ID_read_data_1        : out std_logic_vector(31 downto 0);
            ID_read_data_2        : out std_logic_vector(31 downto 0);
            ID_se_immediate       : out std_logic_vector(31 downto 0);
            ID_funct              : out std_logic_vector(5 downto 0);
            ID_read_address_1     : out std_logic_vector(4 downto 0);
            ID_read_address_2     : out std_logic_vector(4 downto 0);
            ID_write_address      : out std_logic_vector(4 downto 0)
        );
    end component id_stage;

    -- Declare Signals
    signal
        PC_branch_address,
        PC_pc,
        PC_predicted_address,
        PC_fallback_address,
        IF_pc,
        IF_instruction,
        IF_predicted_address,
        IF_fallback_address,
        ID_pc,
        ID_jump_address,
        ID_predicted_address,
        ID_fallback_address,
        ID_se_immediate,
        ID_read_data_1,
        ID_read_data_2,
        WB_result
    : std_logic_vector(31 downto 0);
    signal
        ID_funct
    : std_logic_vector(5 downto 0);
    signal
        ID_read_address_1,
        ID_read_address_2,
        ID_write_address,
        WB_write_address
    : std_logic_vector(4 downto 0);
    signal
        ID_aluop
    : std_logic_vector(2 downto 0);
    signal
        PC_branch,
        IF_branch,
        ID_jump_execute,
        ID_alusrc,
        ID_branch,
        ID_memwrite,
        ID_memread,
        ID_mem2reg,
        ID_regwrite,
        ID_stackop,
        ID_stackpushpop,
        EX_branch_execute,
        WB_regwrite
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
            pc_in                 => PC_pc,
            predicted_address_in  => PC_predicted_address,
            fallback_address_in   => PC_fallback_address,
            branch                => IF_branch,
            pc_out                => IF_pc,
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
    id_stage_i : id_stage
        port map (
            clk                   => clk,
            branch_execute        => EX_branch_execute,

            -- Previous stage input
            pc_in                 => IF_pc,
            predicted_address_in  => IF_predicted_address,
            fallback_address_in   => IF_fallback_address,
            instruction           => IF_instruction,

            -- WB Data
            WB_result             => WB_result,
            WB_write_address      => WB_write_address,
            WB_regwrite           => WB_regwrite,

            -- Jump
            jump_address          => ID_jump_address,
            jump_execute          => ID_jump_execute,

            -- Addresses
            pc_out                => ID_pc,
            predicted_address_out => ID_predicted_address,
            fallback_address_out  => ID_fallback_address,

            -- Signals
            ID_aluop              => ID_aluop,
            ID_alusrc             => ID_alusrc,
            ID_branch             => ID_branch,
            ID_memwrite           => ID_memwrite,
            ID_memread            => ID_memread,
            ID_mem2reg            => ID_mem2reg,
            ID_regwrite           => ID_regwrite,
            ID_stackop            => ID_stackop,
            ID_stackpushpop       => ID_stackpushpop,

            -- EX data
            ID_read_data_1        => ID_read_data_1,
            ID_read_data_2        => ID_read_data_2,
            ID_read_address_1     => ID_read_address_1,
            ID_read_address_2     => ID_read_address_2,
            ID_se_immediate       => ID_se_immediate,
            ID_funct              => ID_funct,
            ID_write_address      => ID_write_address
        );


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
