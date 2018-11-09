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
	component SignExtend is
		port(
			x: in std_logic_vector(15 downto 0);
			y: out std_logic_vector(31 downto 0));
	end component;
	component ShiftLeft2 is
		port(
			x: in std_logic_vector(31 downto 0);
			y: out std_logic_vector(31 downto 0));
	end component;
	component ShiftLeft2Jump is
		port(
			x: in std_logic_vector(3 downto 0);
			y: in std_logic_vector(25 downto 0);
			z: out std_logic_vector(32-1 downto 0));
	end component;
	component mux5 is
		port(
			x,y: in std_logic_vector(4 downto 0);
			sel: in std_logic;
			z: out std_logic_vector(4 downto 0));
	end component;
	component mux32 is
		port(
			x,y: in std_logic_vector(31 downto 0);
			sel: in std_logic;
			z: out std_logic_vector(31 downto 0));
	end component;
	component And2 is
		port(
			x,y: in std_logic;
			z: out std_logic);
	end component;
	component ALU32 is
		generic(
			n: natural := 32);
		port(
			a,b: in std_logic_vector(n-1 downto 0);
			Oper: in std_logic_vector(3 downto 0);
			Result: buffer std_logic_vector(n-1 downto 0);
			Zero,Overflow: buffer std_logic);
	end component;
	component registers is
		port(
			RR1,RR2,WR: in std_logic_vector(4 downto 0);
			WD,WS: in std_logic_vector(31 downto 0);
			Clk,RegWrite: in std_logic;
			StackOps: in std_logic_vector(1 downto 0);
			RD1,RD2: out std_logic_vector(31 downto 0));
	end component;
	component InstMemory is
		port(
			Address: in std_logic_vector(31 downto 0);
			ReadData: out std_logic_vector(31 downto 0));
	end component;
	component DataMemory is
		port(
			WriteData: in std_logic_vector(31 downto 0);
			Address: in std_logic_vector(31 downto 0);
			MemRead,MemWrite,CLK: in std_logic;
			StackOps: in std_logic_vector(1 downto 0);
			ReadData: out std_logic_vector(31 downto 0));
	end component;
	component ALUControl is
		port(
			ALUOp: in std_logic_vector(1 downto 0);
			Funct: in std_logic_vector(5 downto 0);
			Operation: out std_logic_vector(3 downto 0));
	end component;
	component Control is
		port(
			Opcode: in std_logic_vector(5 downto 0);
			RegDst, Branch, MemRead, MemtoReg: out std_logic;
			ALUSrc, RegWrite, Jump, MemWrite: out std_logic;
			ALUOp, StackOps: out std_logic_vector(1 downto 0));
	end component;
	component MUX32_2 is
		port(
			x, y: in std_logic_vector (31 downto 0);
		    sel: in std_logic_vector(1 downto 0);
		    z: out std_logic_vector(31 downto 0));
	end component;
	component MUX32_4 is
		port(
			w, v, x, y: in std_logic_vector (31 downto 0);
		    sel: in std_logic_vector(1 downto 0);
		    z: out std_logic_vector(31 downto 0));
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
		SelectedAluSrc2,
		MemAddress:
	std_logic_vector(31 downto 0);
	signal
		SelectedWriteReg:
	std_logic_vector(4 downto 0);
	signal
		BranchOpResult:
	std_logic;
	signal
		RegDst,
		Branch,
		MemRead,
		MemtoReg,
		MemWrite,
		ALUSrc,
		RegWrite,
		Jump,
		Zero,
		DelayedClock:
	std_logic;
	signal
		ALUOp,
		StackOps:
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
	Add4: ALU32
		port map(
			a=>PC,
			b=>four,
			Oper=>"0010",
			Result=>PCPlus4,
			Zero=>open,
			Overflow=>open);

	-- Instruction Decode
	Control1: Control
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
			ALUOp=>ALUOp,
			StackOps=>StackOps);
	Mux1: mux
		generic map(5)
		port map(
			x=>Instruction(20 downto 16),
			y=>Instruction(15 downto 11),
			sel=>RegDst,
			z=>SelectedWriteReg);
	Register1:registers
		port map(
			RR1=>Instruction(25 downto 21),
			RR2=>Instruction(20 downto 16),
			WR=>SelectedWriteReg,
			WD=>MemWriteData,
			RegWrite=>RegWrite,
			StackOps=>StackOps,
			Clk=>clk,
			RD1=>RegisterData1,
			RD2=>RegisterData2,
			WS=>AluResult);
	SignExtend1:SignExtend
		port map(
			Instruction(15 downto 0),
			SignExtendedImmediate);
	ShiftJump:ShiftLeft2Jump
		port map(
			PCPlus4(31 downto 28),
			Instruction(25 downto 0),
			JumpAddress);

	-- Execute
	Mux2: mux
		generic map(32)
		port map(
			x=>RegisterData2,
			y=>SignExtendedImmediate,
			sel=>ALUSrc,
			z=>ImmediateOrReg);
	ALUControl1:ALUControl
		port map(
			AluOp=>ALUOp,
			Funct=>Instruction(5 downto 0),
			Operation=>Operation);
	ALU1:ALU32
		port map(
			a=>RegisterData1,
			b=>SelectedAluSrc2,
			Oper=>Operation,
			Result=>AluResult,
			Zero=>Zero,
			Overflow=>open);
	Shift1:ShiftLeft2
		port map(
			SignExtendedImmediate,
			ShiftedBranchOffset);
	AddALU:ALU32
		port map(
			a=>PCPlus4,
			b=>ShiftedBranchOffset,
			Oper=>"0010",
			Result=>BranchAddress,
			Zero=>open,
			Overflow=>open);
	And1:And2
		port map(
			Branch,
			Zero,
			BranchOpResult);
	Mux3: mux
		generic map(32)
		port map(
			x=>PCPlus4,
			y=>BranchAddress,
			sel=>BranchOpResult,
			z=>BranchOrPCPlus4);
	Mux55: mux
		generic map(32)
		port map(
			x=>BranchOrPCPlus4,
			y=>JumpAddress,
			sel=>Jump,
			z=>NextPC);
	Mux32_41:MUX32_4
		port map(
			ImmediateOrReg,
			ImmediateOrReg,
			four,
			neg_four,
			StackOps,
			SelectedAluSrc2);

	-- Memory
	Mux4: mux
		generic map(32)
		port map(
			x=>AluResult,
			y=>MemReadData,
			sel=>MemtoReg,
			z=>MemWriteData);
	Mux6: mux
		generic map(32)
		port map(
			x=>RegisterData2,
			y=>SignExtendedImmediate,
			sel=>StackOps(0),
			z=>MemWriteData);
	Mux32_21:MUX32_2
		port map(
			AluResult,
			RegisterData1,
			StackOps,
			MemAddress);
	DMemory:DataMemory
		port map(
			WriteData=>MemWriteData,
			Address=>MemAddress,
			MemRead=>MemRead,
			MemWrite=>MemWrite,
			CLK=>DelayedClock,
			StackOps=>StackOps,
			ReadData=>MemReadData);

end structure;
