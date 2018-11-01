-- MIPS 32 CPU Pipeline Arch
-- Author:  Anshul Kharbanda
-- Created: 11 - 1 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity cpu is
    port(CLK: in std_logic);
end cpu;

architecture arch of cpu is
    -- Components
    component mux is
        generic(n: natural := 32);
        port(
            x0,x1: in std_logic_vector(n-1 downto 0);
            sel: in std_logic;
            z: out std_logic_vector(n-1 downto 0)
        );
    end component;
    component reg is
        generic (n: natural := 32);
        port(
            CLK: in std_logic;
            x: in std_logic_vector(n-1 downto 0);
            y: out std_logic_vector(n-1 downto 0)
        );
    end component;
    component InstMemory is
        port(
            Address:in std_logic_vector(31 downto 0);
            ReadData:out std_logic_vector(31 downto 0)
        );
    end component;
    component ALU32 is
        generic(n : natural := 32);
        port(a,b : in std_logic_vector(n-1 downto 0);
             Oper : in std_logic_vector(3 downto 0);
             Result : buffer std_logic_vector(n-1 downto 0);
             Zero, Overflow : buffer std_logic);
    end component;
    component if_reg is
        port(
            CLK: in std_logic;
            pc_plus4_in: in std_logic_vector(31 downto 0);
            instruction_in: in std_logic_vector(31 downto 0);
            pc_plus4_out: out std_logic_vector(31 downto 0);
            instruction_out: out std_logic_vector(31 downto 0)
        );
    end component;


    -- Signals
    signal
        next_pc,
        pc,
        pc_plus4,
        if_pc_plus4,
        instruction,
        if_instruction:
        std_logic_vector(31 downto 0);
    signal
        selected_write_register:
        std_logic_vector(4 downto 0);

begin

-- IF

-- program counter
program_counter: reg
    generic map(32)
    port map(
        CLK=>CLK,
        x=>next_pc,
        y=>pc);
-- instruction fetch
instruction_fetch: InstMemory
    port map(
        Address=>pc,
        ReadData=>instruction);

-- pc + 4
pc_plus_4: ALU32
    generic map(32)
    port map(
        a=>pc,
        b=>(2=>'1', others=>'0'), -- FOUR
        Oper=>"0010", -- ADD
        Result=>pc_plus4,
        Zero=>open,
        Overflow=>open);
next_pc <= pc_plus4;

-- IF Register
if_register: if_reg
    port map(
        CLK=>CLK,
        pc_plus4_in=>pc_plus4,
        instruction_in=>instruction,
        pc_plus4_out=>if_pc_plus4,
        instruction_out=>if_instruction
    );

-- ID

-- jump address
-- controller signals
-- selected dest register
-- register data
-- sign extended immediate

-- EX

-- ALU
-- Branch and
-- Branch address
-- Mux branch
-- Mux jump

-- MEM

-- memory

-- WB

-- select

end arch;
