-- MIPS 32 CPU Pipeline Arch
-- Author:  Anshul Kharbanda
-- Created: 11 - 1 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity ID_Stage is
    port(
        -- Inputs
            CLK: in std_logic;
            PCPlus4In,Instruction: in std_logic_vector(31 downto 0);
            WBR: in std_logic_vector(4 downto 0);
            WD,WS: in std_logic_vector(31 downto 0);
            RegWriteIn, StackOpIn, StackPushPopIn: in std_logic;
        -- Outputs
            RD1,RD2,Immediate,JumpAddress,PCPlus4Out: out std_logic_vector(31 downto 0);
            WR: out std_logic_vector(4 downto 0);
            Jump, Branch, MemRead, MemtoReg, MemWrite: out std_logic;
            ALUSrc, RegWriteOut, StackOpOut, StackPushPopOut: out std_logic;
            ALUOp: out std_logic_vector(1 downto 0);
            Funct: out std_logic_vector(5 downto 0)
    );
end ID_Stage;

architecture arch of ID_Stage is
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
			WD, WS: in std_logic_vector(31 downto 0);
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

    signal
        RD1Signal,
        RD2Signal,
        ImmediateSignal,
        JumpAddressSignal:
    std_logic_vector(31 downto 0);
    signal
        WRSignal:
    std_logic_vector(4 downto 0);
    signal
        RegDstSignal,
        BranchSignal,
        MemReadSignal,
        MemtoRegSignal,
        ALUSrcSignal,
        RegWriteSignal,
        JumpSignal,
        MemWriteSignal,
        StackOpSignal,
        StackPushPopSignal:
    std_logic;
    signal
        ALUOpSignal:
    std_logic_vector(1 downto 0);
begin
    Controller: Control
		port map(
			Opcode=>Instruction(31 downto 26),
			RegDst=>RegDstSignal,
			Branch=>BranchSignal,
			MemRead=>MemReadSignal,
			MemtoReg=>MemtoRegSignal,
			MemWrite=>MemWriteSignal,
			ALUSrc=>ALUSrcSignal,
			RegWrite=>RegWriteSignal,
			Jump=>JumpSignal,
			StackOp=>StackOpSignal,
			StackPushPop=>StackPushPopSignal,
			ALUOp=>ALUOpSignal);
    Branchreg: reg1 port map(CLK, BranchSignal, Branch);
    MemReadreg: reg1 port map(CLK, MemReadSignal, MemRead);
    MemtoRegreg: reg1 port map(CLK, MemtoRegSignal, MemtoReg);
    ALUSrcreg: reg1 port map(CLK, ALUSrcSignal, ALUSrc);
    RegWritereg: reg1 port map(CLK, RegWriteSignal, RegWriteOut);
    Jumpreg: reg1 port map(CLK, JumpSignal, Jump);
    MemWritereg: reg1 port map(CLK, MemWriteSignal, MemWrite);
    StackOpreg: reg1 port map(CLK, StackOpSignal, StackOpOut);
    StackPushPopreg: reg1 port map(CLK, StackPushPopSignal, StackPushPopOut);
    ALUOpreg: reg generic map(2) port map(CLK, ALUOpSignal, ALUOp);

	MuxForSelectedWriteReg: mux
		generic map(5)
		port map(
			x=>Instruction(20 downto 16),
			y=>Instruction(15 downto 11),
			sel=>RegDstSignal,
			z=>WRSignal);
    WRReg: reg generic map(5) port map(CLK, WRSignal, WR);

	Registers1: registers
		port map(
			RR1=>Instruction(25 downto 21),
			RR2=>Instruction(20 downto 16),
			WR=>WBR,
			WD=>WD,
			WS=>WS, -- Update Stack Pointer
			RegWrite=>RegWriteIn,
			StackOp=>StackOpIn,
			StackPushPop=>StackPushPopIn,
			Clk=>CLK,
			RD1=>RD1Signal,
			RD2=>RD2Signal);
    RD1reg: reg generic map(32) port map(CLK, RD1Signal, RD1);
    RD2reg: reg generic map(32) port map(CLK, RD2Signal, RD2);

	MakeImmediate: SignExtend
		port map(
			Instruction(15 downto 0),
			ImmediateSignal);
    Immediatereg: reg generic map(32) port map(CLK, ImmediateSignal, Immediate);

	ShiftJump: ShiftLeft2Jump
		port map(
			PCPlus4In(31 downto 28),
			Instruction(25 downto 0),
			JumpAddressSignal);
    JumpAddressReg: reg generic map(32) port map(CLK, JumpAddressSignal, JumpAddress);

    PCPlus4Reg: reg generic map(32) port map(CLK, PCPlus4In, PCPlus4Out);
    FunctReg: reg generic map(6) port map(CLK, Instruction(5 downto 0), Funct);
end arch;
