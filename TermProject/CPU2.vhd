-- MIPS CPU
--
-- Created By: Anup Das/Sihao Song
library ieee;
use ieee.std_logic_1164.all;

-- MAIN CPU COMPONENT
entity CPU2 is
    port(clk:in std_logic;
        CarryOut, Overflow: out std_logic);
end CPU2;

architecture struc of CPU2 is

-- Instruction Memory
component InstMemory
port(Address:in std_logic_vector(31 downto 0);
     ReadData:out std_logic_vector(31 downto 0));
end component;

-- Register Table
component RegistersWR
port(RR1,RR2,WR:in std_logic_vector(4 downto 0);
       WD:in std_logic_vector(31 downto 0);
       CLK,RegWrite:in std_logic;
       RD1,RD2:out std_logic_vector(31 downto 0));
end component;

-- ALU
component ALU
generic(n:natural:=32);
port(a,b:in std_logic_vector(n-1 downto 0);
	 Oper:in std_logic_vector(3 downto 0);
	 Result:buffer std_logic_vector(n-1 downto 0);
	 Zero,Overflow:buffer std_logic);
end component;

-- Data Memory
component DataMemoryWR
port(WriteData:in std_logic_vector(31 downto 0);
     Address:in std_logic_vector(31 downto 0);
     CLK,MemRead,MemWrite:in std_logic;
     ReadData:out std_logic_vector(31 downto 0));
end component;

-- System Controller
component Control2
port(Opcode:in std_logic_vector(5 downto 0);
     RegDst,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,Jump: out std_logic;
     ALUOp: out std_logic_vector(1 downto 0));
end component;

-- ALU Controller
component ALUControl
port(ALUOp:in std_logic_vector(1 downto 0);
     Funct:in std_logic_vector(5 downto 0);
     Operation:out std_logic_vector(3 downto 0));
end component;

-- Program Counter
component PC2
port(clk:in std_logic;
     AddressIn:in std_logic_vector(31 downto 0);
     AddressOut:out std_logic_vector(31 downto 0));
end component;

-- Sign Extend for Immediate
component SignExtend
port(x:in std_logic_vector(15 downto 0);
     y:out std_logic_vector(31 downto 0));
end component;

-- Shift left 2
component ShiftLeft2
port(x:in std_logic_vector(31 downto 0);
     y:out std_logic_vector(31 downto 0));
end component;

-- Shift left 2 for Jump
component ShiftLeft2Jump
port(x:in std_logic_vector(3 downto 0);
     y:in std_logic_vector(25 downto 0);
     z:out std_logic_vector(31 downto 0));
end component;

-- Demux for 5-bit
component MUX5
port(x,y:in std_logic_vector (4 downto 0);
     sel:in std_logic;
     z:out std_logic_vector(4 downto 0));
end component;

-- Demux for
component MUX32
port(x,y:in std_logic_vector (31 downto 0);
     sel:in std_logic;
     z:out std_logic_vector(31 downto 0));
end component;

-- Branch Adder
component AND2
port(x,y:in std_logic;
     z:out std_logic);
end component;

-- Signals

-- Clock signals
signal clk2: std_logic;

-- Constant signals
signal constFour: std_logic_vector(31 downto 0) := (2=>'1',others=>'0');
signal constAdd: std_logic_vector(3 downto 0):="0010";

-- Instruction
signal Instruction: std_logic_vector(31 downto 0);

-- Signals
signal sigWriteRegisterAddress: std_logic_vector(4 downto 0);
signal sigPC,
       sigPCPlus4,
       sigRegisterData1,
       sigRegisterData2,
       sigSignExtendedImmediate,
       sigALUSrc2,
       sigALUResult,
       sigMemReadData,
       sigWriteData,
       sigShiftedBranchAddress,
       sigALUResult,
       sigNextAddressBranch,
       sigBranchOrPlus4Result,
       sigNextAddress,
       sigNextAddressJump:
       std_logic_vector (31 downto 0);
signal sigBranchResult: std_logic;

-- Control Signals
signal RegDst,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,Jump,Zero: std_logic;
signal ALUOp:std_logic_vector(1 downto 0);

-- ALU Operation signal
signal Operation:std_logic_vector(3 downto 0);

begin

-- Clock next
clk2 <= clk after 1 ns;

-- Instruction Read (IR)

-- Program counter
program_counter:PC2
    port map(
        clk => clk,
        AddressIn => sigNextAddress,
        AddressOut => sigA);

-- Read instruction
instruction_memory: InstMemory
    port map(
        Address => sigPC,
        ReadData => Instruction);

-- Increment program counter
program_counter_increment: ALU
    port map(
        a => sigPC,
        b => constFour,
        Oper => constAdd,
        Result => sigPCPlus4,
        Zero => open,
        Overflow => open);

-- Instruction Decode (ID)

-- Control Map
controller: Control2
    port map(
        Opcode => Instruction(31 downto 26),
        RegDst => RegDst,
        Branch => Branch,
        MemRead => MemRead,
        MemtoReg => MemtoReg,
        MemWrite => MemWrite,
        ALUSrc => ALUSrc,
        RegWrite => RegWrite,
        Jump => Jump,
        ALUOp => ALUOp);

-- Reg destination mux
reg_dist_mux: MUX5
    port map(
        x => Instruction(20 downto 16),
        y => Instruction(15 downto 11),
        sel => RegDst,
        z => sigWriteRegisterAddress);

-- Register Map
registers: registersWR
    port map(
        RR1 => Instruction(25 downto 21),
        RR2 => Instruction(20 downto 16),
        WR => sigWriteRegisterAddress,
        WD => sigWriteData,
        CLK => clk,
        RegWrite => RegWrite,
        RD1 => sigRegisterData1,
        RD2 => sigRegisterData2);

-- Immediate branch sign extend
sign_extend_for_immediate: SignExtend
    port map(
        x => Instruction(15 downto 0),
        y => sigSignExtendedImmediate);

-- Shift left 2 and adjust with jump address
shift_left_for_jump: ShiftLeft2Jump port map(
    x => sigPC(31 downto 28),
    y => Instruction(25 downto 0),
    z => sigNextAddressJump);

-- Execute instruction (EX)

-- ALU Controller
alu_controller: ALUControl
    port map(
        ALUOp => ALUOp,
        Funct => Instruction(5 downto 0),
        Operation => Operation);

-- ALU Source mux
alu_src_mux: MUX32
    port map(
        x => sigRegisterData2,
        y => sigSignExtendedImmediate,
        sel => ALUSrc,
        z => sigALUSrc2);

-- MAIN ALU
main_alu: ALU
    port map(
        a => sigRegisterData1,
        b => sigALUSrc2,
        Oper => Operation,
        Result => sigALUResult,
        Zero => Zero,
        Overflow => Overflow);

-- Branch And Operation
branch_and: AND2
    port map(
        x => Zero,
        y => Branch,
        z => sigBranchResult);

-- Shift address for branch
shift_branch_address_by2: ShiftLeft2
    port map(
        x => sigSignExtendedImmediate,
        y => sigShiftedBranchAddress);

-- Branch Adder
branch_adder: ALU
    port map(
        a => sigALUResult,
        b => sigShiftedBranchAddress,
        Oper => constAdd,
        Result => sigNextAddressBranch,
        Zero => open,
        Overflow => open);

-- Branch and Jump Mux's
branch_mux: MUX32
    port map(
        x => sigPCPlus4,
        y => sigNextAddressBranch,
        sel => sigBranchResult,
        z => sigBranchOrPlus4Result);
jump_mux: MUX32
    port map(
        x => sigBranchOrPlus4Result,
        y => sigNextAddressJump,
        sel => Jump,
        z => sigNextAddress);

-- Memory (MEM)

-- Data Memory
data_memory: DataMemoryWR
    port map(
        WriteData => sigRegisterData2,
        Address => sigALUResult,
        CLK => clk2,
        MemRead => MemRead,
        MemWrite => MemWrite,
        ReadData => sigMemReadData);

-- Mem 2 Reg mux
mem_2_reg_mux: MUX32
    port map(
        x => sigALUResult,
        y => sigMemReadData,
        sel => MemtoReg,
        z => sigWriteData);

-- Write Back (WB)

end struc;
