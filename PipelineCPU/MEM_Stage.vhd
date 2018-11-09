-- MIPS 32 CPU Pipeline Arch
-- Author:  Anshul Kharbanda
-- Created: 11 - 1 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity MEM_Stage is
    port(
        -- Inputs
            -- CLK
            CLK: in std_logic;
            -- MemReadIn, MemtoRegIn, MemWriteIn
            MemRead, MemWrite: in std_logic;
            -- RegWriteIn, StackOpIn, StackPushPopIn
            RegWriteIn, MemtoRegIn, StackOpIn, StackPushPopIn: in std_logic;
            -- WRIn
            WRIn: in std_logic_vector(4 downto 0);
            -- ALU Result
            RD2, Immediate, ALUResult, NextPCIn: out std_logic_vector(31 downto 0);
        -- Outputs
            -- RegWriteOut, StackOpOut, StackPushPopOut
            RegWriteOut, MemtoRegOut, StackOpOut, StackPushPopOut: out std_logic;
            -- WROut
            WROut: out std_logic_vector(4 downto 0);
            -- Next PC Out
            NextPCOut: out std_logic_vector(31 downto 0)
    );
end MEM_Stage;

architecture arch of MEM_Stage is
    -- Components
    component reg1 is
        port(
            clk: in std_logic;
            x: in std_logic;
            y: out std_logic
        );
    end component;
	component reg is
		generic (n: natural := 32);
		port(
			clk: in std_logic;
			x: in std_logic_vector(n-1 downto 0);
			y: out std_logic_vector(n-1 downto 0)
		);
	end component;
    component mux is
		generic (n: natural := 32);
		port (
	        x: in std_logic_vector(n-1 downto 0);
	        y: in std_logic_vector(n-1 downto 0);
	        sel: in std_logic;
	        z: out std_logic_vector(n-1 downto 0)
	    );
	end component;
    component DataMemory is
		port(
			WriteData: in std_logic_vector(31 downto 0);
			Address: in std_logic_vector(31 downto 0);
			MemRead, MemWrite, CLK: in std_logic;
			ReadData: out std_logic_vector(31 downto 0));
	end component;

    signal
        MemAddress,
        MemWriteData:
    std_logic_vector(31 downto 0);
begin
    -- Memory
	MuxForMemWriteStackOp: mux
		generic map(32)
		port map(
			x=>RD2,
			y=>Immediate,
			sel=>StackOpStackOpIn,
			z=>MemWriteData);
	StackPop <= StackOpIn and (not StackPushPopIn);
	MuxForStackPop: mux
		generic map(32)
		port map(
			AluResult,
			RegisterData1,
			StackPop,
			MemAddress
		);
	DataMem: DataMemory
		port map(
			WriteData=>MemWriteData,
			Address=>MemAddress,
			MemRead=>MemRead,
			MemWrite=>MemWrite,
			CLK=>DelayedClock,
			ReadData=>MemReadData);
end arch;
