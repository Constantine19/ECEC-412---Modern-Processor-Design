-- ID Stage
-- Author:  Anshul Kharbanda
-- Created: 11 - 29 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ID Stage entity
entity id_stage is
    port (
        clk: in std_logic;
        id_stall: in std_logic;

        -- Previous stage input
        pc_in: in std_logic_vector(31 downto 0);
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
        pc_out: out std_logic_vector(31 downto 0);
        predicted_address_out: out std_logic_vector(31 downto 0);
        fallback_address_out: out std_logic_vector(31 downto 0);

        -- Signals
        ID_aluop : out std_logic_vector(2 downto 0);
        ID_alusrc, ID_branch,
        ID_memwrite, ID_mem2reg,
        ID_regwrite,
        ID_stackop,
        ID_stackpushpop : out std_logic;

        -- EX data
        ID_read_data_1 : out std_logic_vector(31 downto 0);
        ID_read_data_2 : out std_logic_vector(31 downto 0);
        ID_read_address_1 : out std_logic_vector(4 downto 0);
        ID_read_address_2 : out std_logic_vector(4 downto 0);
        ID_se_immediate : out std_logic_vector(31 downto 0);
        ID_funct : out std_logic_vector(5 downto 0);
        ID_write_address : out std_logic_vector(4 downto 0)
    );
end entity;

-- ID Stage architecture
architecture arch of id_stage is
    -- Declare components
    component control
        port (
            opcode : in  std_logic_vector(5 downto 0);
            aluop : out std_logic_vector(2 downto 0);
            regsrc, jump,
            alusrc, branch,
            memwrite, mem2reg,
            regwrite,
            stackop,
            stackpushpop : out std_logic
        );
    end component control;
    component register_table
        generic (
            addr_size  : natural := 5;
            value_size : natural := 32;
            table_size : natural := 32
        );
        port (
            clk                   : in  std_logic;
            raddr1, raddr2, waddr : in  std_logic_vector(addr_size-1 downto 0);
            wvalue                : in  std_logic_vector(value_size-1 downto 0);
            write, stackop        : in  std_logic;
            rvalue1, rvalue2      : out std_logic_vector(value_size-1 downto 0)
        );
    end component register_table;
    component handle_jump
        port (
            predicted_address : in  std_logic_vector(31 downto 0);
            pc                : in  std_logic_vector(31 downto 0);
            jump_code         : in  std_logic_vector(25 downto 0);
            jump_address      : out std_logic_vector(31 downto 0);
            jump              : in  std_logic;
            jump_execute      : out std_logic
        );
    end component handle_jump;

    -- Declare signals
    signal
        q_pc,
        q_predicted_address,
        q_fallback_address,
        d_read_data_1, q_read_data_1,
        d_read_data_2, q_read_data_2,
        d_se_immediate, q_se_immediate
    : std_logic_vector(31 downto 0);
    signal
        d_read_address_1, q_read_address_1,
        d_read_address_2, q_read_address_2,
        d_write_address, q_write_address
    : std_logic_vector(4 downto 0);
    signal
        opcode, d_funct, q_funct
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
        d_mem2reg, q_mem2reg,
        d_regwrite, q_regwrite,
        d_stackop, q_stackop,
        d_stackpushpop, q_stackpushpop
    : std_logic;

    -- Declare constants
    constant undef : std_logic_vector(5 downto 0) := "XXXXXX";
    constant zero : std_logic_vector(15 downto 0) := (others => '0');
    constant ffff : std_logic_vector(15 downto 0) := (others => '1');
begin
    -- Get opcode
    opcode <= undef when id_stall='1' else instruction(31 downto 26);

    -- Compute Read Addresses
    d_read_address_1 <= instruction(25 downto 21);
    d_read_address_2 <= instruction(20 downto 16);

    -- Compute Funct
    d_funct <= instruction(5 downto 0);

    -- Compute Write Address
    d_write_address <=
        instruction(20 downto 16) when regsrc='1' else
        instruction(15 downto 11);

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
            mem2reg      => d_mem2reg,
            regwrite     => d_regwrite,
            stackop      => d_stackop,
            stackpushpop => d_stackpushpop
        );

    -- Jump
    handle_jump_i : handle_jump
        port map (
            predicted_address => predicted_address_in,
            pc                => pc_in,
            jump_code         => instruction(25 downto 0),
            jump              => jump,
            jump_address      => jump_address,
            jump_execute      => jump_execute
        );

    -- Read Registers
    register_table_i : register_table
        generic map (
            addr_size  => 5,
            value_size => 32,
            table_size => 32
        )
        port map (
            clk     => clk,
            raddr1  => d_read_address_1,
            raddr2  => d_read_address_2,
            waddr   => WB_write_address,
            wvalue  => WB_result,
            write   => WB_regwrite,
            stackop => d_stackop,
            rvalue1 => d_read_data_1,
            rvalue2 => d_read_data_2
        );

    -- SE Immediate
    d_se_immediate <=
        ffff & instruction(15 downto 0) when instruction(15)='1' else
        zero & instruction(15 downto 0);

    -- Commit
    q_pc <= pc_in when clk'event and clk='1' else q_pc;
    q_predicted_address <= predicted_address_in when clk'event and clk='1' else q_predicted_address;
    q_fallback_address <= fallback_address_in when clk'event and clk='1' else q_fallback_address;
    q_aluop <= d_aluop when clk'event and clk='1' else q_aluop;
    q_alusrc <= d_alusrc when clk'event and clk='1' else q_alusrc;
    q_branch <= d_branch when clk'event and clk='1' else q_branch;
    q_memwrite <= d_memwrite when clk'event and clk='1' else q_memwrite;
    q_mem2reg <= d_mem2reg when clk'event and clk='1' else q_mem2reg;
    q_regwrite <= d_regwrite when clk'event and clk='1' else q_regwrite;
    q_stackop <= d_stackop when clk'event and clk='1' else q_stackop;
    q_stackpushpop <= d_stackpushpop when clk'event and clk='1' else q_stackpushpop;
    q_read_address_1 <= d_read_address_1 when clk'event and clk='1' else q_read_address_1;
    q_read_address_2 <= d_read_address_2 when clk'event and clk='1' else d_read_address_2;
    q_write_address <= d_write_address when clk'event and clk='1' else q_write_address;
    q_read_data_1 <= d_read_data_1 when clk'event and clk='1' else q_read_data_1;
    q_read_data_2 <= d_read_data_2 when clk'event and clk='1' else q_read_data_2;
    q_se_immediate <= d_se_immediate when clk'event and clk='1' else q_se_immediate;
    q_funct <= d_funct when clk'event and clk='1' else q_funct;

    -- Output
    pc_out <= q_pc;
    predicted_address_out <= q_predicted_address;
    fallback_address_out <= q_fallback_address;
    ID_aluop <= q_aluop;
    ID_alusrc <= q_alusrc;
    ID_branch <= q_branch;
    ID_memwrite <= q_memwrite;
    ID_mem2reg <= q_mem2reg;
    ID_regwrite <= q_regwrite;
    ID_stackop <= q_stackop;
    ID_stackpushpop <= q_stackpushpop;
    ID_read_address_1 <= q_read_address_1;
    ID_read_address_2 <= q_read_address_2;
    ID_write_address <= q_write_address;
    ID_funct <= q_funct;
    ID_read_data_1 <= q_read_data_1;
    ID_read_data_2 <= q_read_data_2;
    ID_se_immediate <= q_se_immediate;
end architecture;
