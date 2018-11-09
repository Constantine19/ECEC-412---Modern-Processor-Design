library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CPU is
	port(
		clk: in std_logic;
		Overflow: out std_logic);
end CPU;

architecture structure of CPU is
	-- Component
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
	component InstMemory is
		port(
			Address: in std_logic_vector(31 downto 0);
			ReadData: out std_logic_vector(31 downto 0));
	end component;
	component Control is
		port(
			Opcode: in std_logic_vector(5 downto 0);
			RegDst, Branch, MemRead, MemtoReg, ALUSrc, RegWrite: out std_logic;
			Jump, MemWrite, StackOp, StackPushPop: out std_logic;
			ALUOp: out std_logic_vector(1 downto 0));
	end component;
	component registers is
		port(
			RR1, RR2, WR: in std_logic_vector(4 downto 0);
			WD: in std_logic_vector(31 downto 0);
			Clk, RegWrite, StackOp, StackPushPop: in std_logic;
			RD1, RD2: out std_logic_vector(31 downto 0));
	end component;
	component SignExtend is
		port(
			x: in std_logic_vector(15 downto 0);
			y: out std_logic_vector(31 downto 0));
	end component;
	component ShiftLeft2Jump is
		port(
			x: in std_logic_vector(3 downto 0);
			y: in std_logic_vector(25 downto 0);
			z: out std_logic_vector(32-1 downto 0));
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
	component DataMemory is
		port(
			WriteData: in std_logic_vector(31 downto 0);
			Address: in std_logic_vector(31 downto 0);
			MemRead, MemWrite, CLK, StackOp, StackPushPop: in std_logic;
			ReadData: out std_logic_vector(31 downto 0));
	end component;

	-- Declare Signals based on Single Cycle CPU
	signal
		Instruction,
		PC,
		RegisterData1,
		RegisterData2,
		SignExtendedImmediate,
		ImmediateOrReg,
		AluResult,
		MemReadData,
		MemWriteData,
		ShiftedBranchOffset,
		PCPlus4,
		BranchAddress,
		BranchOrPCPlus4,
		NextPC,
		JumpAddress,
		StackOpOffset,
		SelectedAluSrc2,
		MemAddress,
		RegWriteData:
	std_logic_vector(31 downto 0);
	signal
		SelectedWriteReg:
	std_logic_vector(4 downto 0);
	signal
		RegDst,
		Branch,
		MemRead,
		MemtoReg,
		MemWrite,
		ALUSrc,
		RegWrite,
		Jump,
		StackOp,
		StackPushPop,
		Zero,
		BranchOpResult,
		StackPop,
		DelayedClock:
	std_logic;
	signal
		ALUOp:
	std_logic_vector(1 downto 0);
	signal
		Operation:
	std_logic_vector(3 downto 0);

	-- Constants
	signal four: std_logic_vector(31 downto 0)
		:= "00000000000000000000000000000100"; -- (2=>'1', others=>'0')
	signal neg_four: std_logic_vector(31 downto 0)
		:= "11111111111111111111111111111100"; -- (2=>'0', 1=>'0', others=>'1')
begin
	-- Delayed clock
	DelayedClock <= clk after 1 ns;

	-- Instruction Fetch
	PC1: reg generic map(32) port map(clk, NextPC, PC);
	InstMem: InstMemory port map(PC, Instruction);
	AddPCPlus4: ALU32
		port map(
			a=>PC,
			b=>four,
			Oper=>"0010",
			Result=>PCPlus4,
			Zero=>open,
			Overflow=>open);

	-- Instruction Decode
	Controller: Control
		port map(
			Opcode=>Instruction(31 downto 26),
			RegDst=>RegDst,
			Branch=>Branch,
			MemRead=>MemRead,
			MemtoReg=>MemtoReg,
			MemWrite=>MemWrite,
			ALUSrc=>ALUSrc,
			RegWrite=>RegWrite,
			Jump=>Jump,
			StackOp=>StackOp,
			StackPushPop=>StackPushPop,
			ALUOp=>ALUOp);
	MuxForSelectedWriteReg: mux
		generic map(5)
		port map(
			x=>Instruction(20 downto 16),
			y=>Instruction(15 downto 11),
			sel=>RegDst,
			z=>SelectedWriteReg);
	Registers1: registers
		port map(
			RR1=>Instruction(25 downto 21),
			RR2=>Instruction(20 downto 16),
			WR=>SelectedWriteReg,
			WD=>RegWriteData,
			RegWrite=>RegWrite,
			StackOp=>StackOp,
			StackPushPop=>StackPushPop,
			Clk=>clk,
			RD1=>RegisterData1,
			RD2=>RegisterData2);
	MakeImmediate: SignExtend
		port map(
			Instruction(15 downto 0),
			SignExtendedImmediate);
	ShiftJump: ShiftLeft2Jump
		port map(
			PCPlus4(31 downto 28),
			Instruction(25 downto 0),
			JumpAddress);

	-- Execute
	MuxForImmediateOrReg: mux
		generic map(32)
		port map(
			x=>RegisterData2,
			y=>SignExtendedImmediate,
			sel=>ALUSrc,
			z=>ImmediateOrReg);
	MuxForStackOfset: mux
		generic map(32)
		port map(
			x=>four,
			y=>neg_four,
			sel=>StackPushPop,
			z=>StackOpOffset);
	MuxForSelectedAluSrc2: mux
		generic map(32)
		port map(
			x=>ImmediateOrReg,
			y=>StackOpOffset,
			sel=>StackOp,
			z=>SelectedAluSrc2);
	ALUControl1: ALUControl
		port map(
			AluOp=>ALUOp,
			Funct=>Instruction(5 downto 0),
			Operation=>Operation);
	MainALU: ALU32
		port map(
			a=>RegisterData1,
			b=>SelectedAluSrc2,
			Oper=>Operation,
			Result=>AluResult,
			Zero=>Zero,
			Overflow=>open);
	BranchShiftLeft: ShiftLeft2
		port map(
			SignExtendedImmediate,
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
			z=>NextPC);

	-- Memory
	MuxForMemWriteStackOp: mux
		generic map(32)
		port map(
			x=>RegisterData2,
			y=>SignExtendedImmediate,
			sel=>StackOp,
			z=>MemWriteData);
	StackPop <= StackOp and (not StackPushPop);
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
			StackOp=>StackOp,
			StackPushPop=>StackPushPop,
			ReadData=>MemReadData);

	-- Write Back
	MuxForWriteBackData: mux
		generic map(32)
		port map(
			x=>AluResult,
			y=>MemReadData,
			sel=>MemtoReg,
			z=>RegWriteData);

end structure;
