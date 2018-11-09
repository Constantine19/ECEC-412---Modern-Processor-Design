-- MIPS 32 CPU Pipeline Arch
-- Author:  Anshul Kharbanda
-- Created: 11 - 1 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity EX_Stage is
    port(
        -- Inputs
            -- CLK
            CLK: in std_logic;
            -- Jump, Branch, ALUSrc
            Jump, Branch, ALUSrc: in std_logic;
            -- MemReadIn, MemtoRegIn, MemWriteIn
            MemReadIn, MemtoRegIn, MemWriteIn: in std_logic;
            -- RegWriteIn, StackOpIn, StackPushPopIn
            RegWriteIn, StackOpIn, StackPushPopIn: in std_logic;
            -- ALUOp
            ALUOp: in std_logic_vector(1 downto 0);
            -- Funct
            Funct: in std_logic_vector(5 downto 0);
            -- WRIn
            WRIn: in std_logic_vector(4 downto 0);
            -- RD1, RD2In, Immediate
            RD1,RD2In,ImmediateIn,PCPlus4: in std_logic_vector(31 downto 0);
        -- Outputs
            -- MemReadOut, MemtoRegOut, MemWriteOut
            MemReadOut, MemtoRegOut, MemWriteOut: out std_logic;
            -- RegWriteOut, StackOpOut, StackPushPopOut
            RegWriteOut, StackOpOut, StackPushPopOut: out std_logic;
            -- WROut
            WROut: out std_logic_vector(4 downto 0);
            -- ALU Result
            ALUResult, NextPC, RD2Out, ImmediateOut: out std_logic_vector(31 downto 0)
    );
end EX_Stage;

architecture arch of EX_Stage is
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
    component ALUControl is
		port(
			ALUOp: in std_logic_vector(1 downto 0);
			Funct: in std_logic_vector(5 downto 0);
			Operation: out std_logic_vector(3 downto 0));
	end component;
	component ALU32 is
		generic(n: natural := 32);
		port(
			a,b: in std_logic_vector(n-1 downto 0);
			Oper: in std_logic_vector(3 downto 0);
			Result: buffer std_logic_vector(n-1 downto 0);
			Zero,Overflow: buffer std_logic);
	end component;
	component ShiftLeft2 is
		port(
			x: in std_logic_vector(31 downto 0);
			y: out std_logic_vector(31 downto 0));
	end component;

    -- Signals
    signal
		ImmediateOrReg,
		ShiftedBranchOffset,
		BranchAddress,
		BranchOrPCPlus4,
		JumpAddress,
		StackOpOffset,
		SelectedAluSrc2,
        ALUResultSignal,
        NextPCSignal:
	std_logic_vector(31 downto 0);
	signal
		SelectedWriteReg:
	std_logic_vector(4 downto 0);
	signal
		Zero,
		BranchOpResult,
		StackPop:
	std_logic;
	signal
		Operation:
	std_logic_vector(3 downto 0);

    -- Constants
	signal four: std_logic_vector(31 downto 0)
		:= "00000000000000000000000000000100"; -- (2=>'1', others=>'0')
	signal neg_four: std_logic_vector(31 downto 0)
		:= "11111111111111111111111111111100"; -- (2=>'0', 1=>'0', others=>'1')
begin
    MuxForImmediateOrReg: mux
		generic map(32)
		port map(
			x=>RD2In,
			y=>ImmediateIn,
			sel=>ALUSrc,
			z=>ImmediateOrReg);
    MuxForStackOfset: mux
		generic map(32)
		port map(
			x=>neg_four,
			y=>four,
			sel=>StackPushPopIn,
			z=>StackOpOffset);
    MuxForSelectedAluSrc2: mux
		generic map(32)
		port map(
			x=>ImmediateOrReg,
			y=>StackOpOffset,
			sel=>StackOpIn,
			z=>SelectedAluSrc2);
    ALUControl1: ALUControl
		port map(
			AluOp=>ALUOp,
			Funct=>Funct,
			Operation=>Operation);
    MainALU: ALU32
		port map(
			a=>RD1,
			b=>SelectedAluSrc2,
			Oper=>Operation,
			Result=>ALUResultSignal,
			Zero=>Zero,
			Overflow=>open);

    BranchShiftLeft: ShiftLeft2
		port map(
			Immediate,
			ShiftedBranchOffset);
    AddBranchShift: ALU32
		port map(
			a=>PCPlus4,
			b=>ShiftedBranchOffset,
			Oper=>"0010",
			Result=>BranchAddress,
			Zero=>open,
			Overflow=>open);
	BranchOpResult <= Branch and Zero;
    MuxForBranchOrPCPlus4: mux
		generic map(32)
		port map(
			x=>PCPlus4,
			y=>BranchAddress,
			sel=>BranchOpResult,
			z=>BranchOrPCPlus4);
    MuxForNextPC: mux
		generic map(32)
		port map(
			x=>BranchOrPCPlus4,
			y=>JumpAddress,
			sel=>Jump,
			z=>NextPCSignal);

    MemReadReg: reg1 port map(CLK, MemReadIn, MemReadOut);
    MemtoRegReg: reg1 port map(CLK, MemtoRegIn, MemtoRegOut);
    MemWriteReg: reg1 port map(CLK, MemWriteIn, MemWriteOut);
    RegWriteReg: reg1 port map(CLK, RegWriteIn, RegWriteOut);
    StackOpReg: reg1 port map(CLK, StackOpIn, StackOpOut);
    StackPushPopReg: reg1 port map(CLK, StackPushPopIn, StackPushPopOut);
    WRReg: reg generic map(5) port map(CLK, WRIn, WROut);
    ALUResultReg: reg generic map(32) port map(CLK, ALUResultSignal, ALUResult);
    NextPCReg: reg generic map(32) port map(CLK, NextPCSignal, NextPC);
    RD2Reg: reg generic map(32) port map(CLK, RD2In, RD2Out);
    ImmediateReg: reg generic map(32) port map(CLK, ImmediateIn, ImmediateOut);
end arch;
