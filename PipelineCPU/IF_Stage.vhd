-- MIPS 32 CPU Pipeline Arch
-- Author:  Anshul Kharbanda
-- Created: 11 - 1 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity IF_Stage is
    port(
        -- Inputs:
            -- CLK
            CLK: in std_logic;
        -- Outputs:
            -- Instruction
            Instruction: out std_logic_vector(31 downto 0);
            -- PC + 4
            PCPlus4: out std_logic_vector(31 downto 0)
    );
end IF_Stage;

architecture arch of IF_Stage is
    -- Components
	component reg is
		generic (n: natural := 32);
		port(
			clk: in std_logic;
			x: in std_logic_vector(n-1 downto 0);
			y: out std_logic_vector(n-1 downto 0)
		);
	end component;
    component reg1 is
        port(
            clk: in std_logic;
            x: in std_logic;
            y: out std_logic
        );
    end component;
    component InstMemory is
		port(
			Address: in std_logic_vector(31 downto 0);
			ReadData: out std_logic_vector(31 downto 0));
	end component;
    component ALU32 is
		generic(n: natural := 32);
		port(
			a,b: in std_logic_vector(n-1 downto 0);
			Oper: in std_logic_vector(3 downto 0);
			Result: buffer std_logic_vector(n-1 downto 0);
			Zero,Overflow: buffer std_logic);
	end component;

    -- Signals
    signal
        InstructionSignal,
        PC,
        NextPC:
    std_logic_vector(31 downto 0);

    -- Constants
    constant four: std_logic_vector(31 downto 0) := (2=>'1', others=>'0');
begin
    -- Program Counter
    PC1: reg
        generic map(32)
        port map(clk, NextPC, PC);

    -- Instruction
    InstMem: InstMemory
        port map(
            Address => PC,
            ReadData => InstructionSignal
        );
    InstMemReg: reg
        generic map(32)
        port map(
            clk => CLK,
            x => InstructionSignal,
            y => Instruction
        );

    -- PC Plus 4
    Add4ToPC: ALU32
        port map(
            a => PC,
            b => four,
            Oper => "0010",
            Result => NextPC,
            Zero => open,
            Overflow => open
        );
    PCPlus4Reg: reg
        generic map(32)
        port map(
            clk => CLK,
            x => NextPC,
            y => PCPlus4
        );
end arch;
