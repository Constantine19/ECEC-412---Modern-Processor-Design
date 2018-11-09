library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CPU is
	port(
		clk: in std_logic;
		Overflow: out std_logic);
end CPU;

architecture structure of CPU is
	-- Stage Components
	component IF_Stage is
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
	end component;

	component ID_Stage is
	    port(
	        -- Inputs
				-- CLK
	            CLK: in std_logic;

				-- PC+4 and Instruction from IF stage
	            PCPlus4In,Instruction: in std_logic_vector(31 downto 0);

				-- Signals from WB Stage
	            WBR: in std_logic_vector(4 downto 0);
	            WD,WS: in std_logic_vector(31 downto 0);
	            RegWriteIn, StackOpIn, StackPushPopIn: in std_logic;
	        -- Outputs
				-- Output Data Signals
	            RD1,RD2,Immediate,JumpAddress,PCPlus4Out: out std_logic_vector(31 downto 0);
	            WR: out std_logic_vector(4 downto 0);

				-- Output Control Signals
	            Jump, Branch, MemRead, MemtoReg, MemWrite: out std_logic;
	            ALUSrc, RegWriteOut, StackOpOut, StackPushPopOut: out std_logic;
	            ALUOp: out std_logic_vector(1 downto 0);
				Funct: out std_logic_vector(5 downto 0)
	    );
	end component;

	component EX_Stage is
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
	            -- RD1, RD2, Immediate
	            RD1,RD2,Immediate,PCPlus4: in std_logic_vector(31 downto 0);
	        -- Outputs
	            -- MemReadOut, MemtoRegOut, MemWriteOut
	            MemReadOut, MemtoRegOut, MemWriteOut: out std_logic;
	            -- RegWriteOut, StackOpOut, StackPushPopOut
	            RegWriteOut, StackOpOut, StackPushPopOut: out std_logic;
	            -- WROut
	            WROut: out std_logic_vector(4 downto 0);
	            -- ALU Result
	            ALUResult, NextPC: out std_logic_vector(31 downto 0)
	    );
	end component;

	-- Signals
	signal
		Instruction,
		PCPlus4_IF,
		PCPlus4_ID,
		RD1_ID,
		RD2_ID,
		Immediate_ID,
		JumpAddress_ID,
		ALUResult_EX,
		NextPC_EX,
		WD_WB,
		WS_WB:
	std_logic_vector(31 downto 0);
	signal
		Funct_ID:
	std_logic_vector(5 downto 0);
	signal
		WR_ID,
		WR_EX,
		WR_WB:
	std_logic_vector(4 downto 0);
	signal
		ALUOp_ID:
	std_logic_vector(1 downto 0);
	signal
		Jump_ID,
		Branch_ID,
		MemRead_ID,
		MemRead_EX,
		MemtoReg_ID,
		MemtoReg_EX,
		MemWrite_ID,
		MemWrite_EX,
		ALUSrc_ID,
		RegWrite_ID,
		RegWrite_EX,
		RegWrite_WB,
		StackOp_ID,
		StackOp_EX,
		StackOp_WB,
		StackPushPop_ID,
		StackPushPop_EX,
		StackPushPop_WB:
	std_logic;
begin

	-- IF Stage
	IFStage: IF_Stage
		port map(
			CLK=>clk,
			Instruction=>Instruction,
			PCPlus4=>PCPlus4_IF
		);

	-- ID Stage
	IDStage: ID_Stage
		port map(
			CLK=>clk,
			PCPlus4In=>PCPlus4_IF,
			Instruction=>Instruction,
			WBR=>WR_WB,
			WD=>WD_WB,
			WS=>WS_WB,
			RegWriteIn=>RegWrite_WB,
			StackOpIn=>StackOp_WB,
			StackPushPopIn=>StackPushPop_WB,
			RD1=>RD1_ID,
			RD2=>RD2_ID,
			Immediate=>Immediate_ID,
			JumpAddress=>JumpAddress_ID,
			PCPlus4Out=>PCPlus4_ID,
			WR=>WR_ID,
			Jump=>Jump_ID,
			Branch=>Branch_ID,
			MemRead=>MemRead_ID,
			MemtoReg=>MemtoReg_ID,
			MemWrite=>MemWrite_ID,
			ALUSrc=>ALUSrc_ID,
			RegWriteOut=>RegWrite_ID,
			StackOpOut=>StackOp_ID,
			StackPushPopOut=>StackPushPop_ID,
			AlUOp=>ALUOp_ID,
			Funct=>Funct_ID
		);

	-- EX Stage
	EXStage: EX_Stage
		port map(
			CLK=>clk,
			-- Jump, Branch, ALUSrc
			Jump=>Jump_ID,
			Branch=>Branch_ID,
			ALUSrc=>ALUSrc_ID,
			-- MemReadIn, MemtoRegIn, MemWriteIn
			MemReadIn=>MemRead_ID,
			MemtoRegIn=>MemtoReg_ID,
			MemWriteIn=>MemWrite_ID,
			-- RegWriteIn, StackOpIn, StackPushPopIn
			RegWriteIn=>RegWrite_ID,
			StackOpIn=>StackOp_ID,
			StackPushPopIn=>StackPushPop_ID,
			-- ALUOp
			ALUOp=>ALUOp_ID,
			-- Funct
			Funct=>Funct_ID,
			-- WRIn
			WRIn=>WR_ID,
			-- RD1, RD2, Immediate
			RD1=>RD1_ID,
			RD2=>RD2_ID,
			Immediate=>Immediate_ID,
			PCPlus4=>PCPlus4_ID,
		-- Outputs
			-- MemReadOut, MemtoRegOut, MemWriteOut
			MemReadOut=>MemRead_EX,
			MemtoRegOut=>MemtoReg_EX,
			MemWriteOut=>MemWrite_EX,
			-- RegWriteOut, StackOpOut, StackPushPopOut
			RegWriteOut=>RegWrite_EX,
			StackOpOut=>StackOp_EX,
			StackPushPopOut=>StackPushPop_EX,
			-- WROut
			WROut=>WR_EX,
			-- ALU Result
			ALUResult=>ALUResult_EX,
			NextPC=>NextPC_EX
		);

end structure;
