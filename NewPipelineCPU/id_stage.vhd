-- ID Stage
-- Author:  Anshul Kharbanda
-- Created: 11 - 29 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity id_stage is
    port (
        clk: in std_logic;
        branch_execute: in std_logic;

        -- Previous stage input
        predicted_address_in: in std_logic_vector(31 downto 0);
        fallback_address_in: in std_logic_vector(31 downto 0);
        instruction: in std_logic_vector(31 downto 0);

        -- WB Data
        WB_result: in std_logic_vector(31 downto 0);
        WB_write_address: in std_logic_vector(4 downto 0);
        WB_regwrite: in std_logic;

        -- Jump
        jump_address: out std_logic_vector(31 downto 0);
        jump_execute: out std_logic;

        -- Addresses
        predicted_address_out: out std_logic_vector(31 downto 0);
        fallback_address_out: out std_logic_vector(31 downto 0);

        -- Signals
        EX_aluop: out std_logic_vector(1 downto 0);
        EX_alusrc, EX_branch,
        EX_memwrite, EX_memread, EX_mem2reg,
        EX_regwrite,
        EX_stackop,
        EX_stackpushpop : out std_logic;

        -- EX data
        EX_read_data_1 : out std_logic_vector(31 downto 0);
        EX_read_data_2 : out std_logic_vector(31 downto 0);
        EX_read_address_1 : out std_logic_vector(31 downto 0);
        EX_read_address_2 : out std_logic_vector(31 downto 0);
        EX_se_immediate: out std_logic_vector(31 downto 0);
        EX_funct: out std_logic_vector(5 downto 0);
        EX_write_address: out std_logic_vector(31 downto 0)
    );
end entity;

architecture arch of id_stage is
    -- Declare components
    component control
        port (
            opcode : in  std_logic_vector(5 downto 0);
            aluop : out std_logic_vector(2 downto 0);
            regsrc, jump,
            alusrc, branch,
            memwrite, memread, mem2reg,
            regwrite,
            stackop,
            stackpushpop : out std_logic
        );
    end component control;


    -- Declare signals
    signal
        opcode
    : std_logic_vector(5 downto 0);
    signal
        jump,
        regsrc,
        stackop
    : std_logic;

    -- Declare constants
    constant undef : std_logic_vector(5 downto 0) := "XXXXXX";
begin
    -- Get opcode
    opcode <= instruction(31 downto 26) when branch_execute='1' else undef;

    -- Compute Read Addresses
    -- Funct
    -- Compute Write Address

    -- Control
    control_i : control
        port map (
            opcode       => opcode,
            aluop        => EX_aluop,
            regsrc       => regsrc,
            jump         => jump,
            alusrc       => EX_alusrc,
            branch       => EX_branch,
            memwrite     => EX_memwrite,
            memread      => EX_memread,
            mem2reg      => EX_mem2reg,
            regwrite     => EX_regwrite,
            stackop      => stackop
            stackpushpop => EX_stackpushpop
        );

    -- Jump
    -- Read Registers
    -- SE Immediate
end architecture;
