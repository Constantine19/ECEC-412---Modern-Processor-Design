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
        ID_aluop: out std_logic_vector(2 downto 0);
        ID_alusrc, ID_branch,
        ID_memwrite, ID_memread, ID_mem2reg,
        ID_regwrite,
        ID_stackop,
        ID_stackpushpop : out std_logic;

        -- EX data
        ID_read_data_1 : out std_logic_vector(31 downto 0);
        ID_read_data_2 : out std_logic_vector(31 downto 0);
        ID_read_address_1 : out std_logic_vector(4 downto 0);
        ID_read_address_2 : out std_logic_vector(4 downto 0);
        ID_se_immediate: out std_logic_vector(31 downto 0);
        ID_funct: out std_logic_vector(5 downto 0);
        ID_write_address: out std_logic_vector(4 downto 0)
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
        d_aluop, q_aluop
    : std_logic_vector(2 downto 0);
    signal
        jump,
        regsrc,
        d_alusrc, q_alusrc,
        d_branch, q_branch,
        d_memwrite, q_memwrite,
        d_memread, q_memread,
        d_mem2reg, q_mem2reg,
        d_regwrite, q_regwrite,
        d_stackop, q_stackop,
        d_stackpushpop, q_stackpushpop
    : std_logic;

    -- Declare constants
    constant undef : std_logic_vector(5 downto 0) := "XXXXXX";
begin
    -- Get opcode
    opcode <= undef when branch_execute='1' else instruction(31 downto 26);

    -- Compute Read Addresses
    -- Funct
    -- Compute Write Address

    -- Control
    control_i : control
        port map (
            opcode       => opcode,
            aluop        => d_aluop,
            regsrc       => regsrc,
            jump         => jump,
            alusrc       => d_alusrc,
            branch       => d_branch,
            memwrite     => d_memwrite,
            memread      => d_memread,
            mem2reg      => d_mem2reg,
            regwrite     => d_regwrite,
            stackop      => d_stackop,
            stackpushpop => d_stackpushpop
        );

    -- Jump
    -- Read Registers
    -- SE Immediate

    -- Commit
    q_aluop <= d_aluop when clk'event and clk='1' else q_aluop;
    q_alusrc <= d_alusrc when clk'event and clk='1' else q_alusrc;
    q_branch <= d_branch when clk'event and clk='1' else q_branch;
    q_memwrite <= d_memwrite when clk'event and clk='1' else q_memwrite;
    q_memread <= d_memread when clk'event and clk='1' else q_memread;
    q_mem2reg <= d_mem2reg when clk'event and clk='1' else q_mem2reg;
    q_regwrite <= d_regwrite when clk'event and clk='1' else q_regwrite;
    q_stackop <= d_stackop when clk'event and clk='1' else q_stackop;
    q_stackpushpop <= d_stackpushpop when clk'event and clk='1' else q_stackpushpop;

    -- Output
    ID_aluop <= q_aluop;
    ID_alusrc <= q_alusrc;
    ID_branch <= q_branch;
    ID_memwrite <= q_memwrite;
    ID_memread <= q_memread;
    ID_mem2reg <= q_mem2reg;
    ID_regwrite <= q_regwrite;
    ID_stackop <= q_stackop;
    ID_stackpushpop <= q_stackpushpop;
end architecture;
