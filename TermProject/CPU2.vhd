library ieee;
use ieee.std_logic_1164.all;
entity CPU2 is
port(clk:in std_logic;CarryOut,Overflow:out std_logic);
end CPU2;
architecture struc of CPU2 is
component RegistersWR
port(RR1,RR2,WR:in std_logic_vector(4 downto 0);
       WD:in std_logic_vector(31 downto 0);
       CLK,RegWrite:in std_logic;
       RD1,RD2:out std_logic_vector(31 downto 0));
end component;
component ALU
generic(n:natural:=32);
port(a,b:in std_logic_vector(n-1 downto 0);
	  Oper:in std_logic_vector(3 downto 0);
	  Result:buffer std_logic_vector(n-1 downto 0);
	  Zero,Overflow:buffer std_logic);
end component;
component InstMemory
port(Address:in std_logic_vector(31 downto 0);
     ReadData:out std_logic_vector(31 downto 0));
end component;
component DataMemoryWR
port(WriteData:in std_logic_vector(31 downto 0);
     Address:in std_logic_vector(31 downto 0);
     CLK,MemRead,MemWrite:in std_logic;
     ReadData:out std_logic_vector(31 downto 0));
end component;
component Control2
port(Opcode:in std_logic_vector(5 downto 0);
     RegDst,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,Jump:out std_logic;
     ALUOp:out std_logic_vector(1 downto 0));
end component;
component ALUControl
port(ALUOp:in std_logic_vector(1 downto 0);
     Funct:in std_logic_vector(5 downto 0);
     Operation:out std_logic_vector(3 downto 0));
end component;
component PC2
port(clk:in std_logic;
     AddressIn:in std_logic_vector(31 downto 0);
     AddressOut:out std_logic_vector(31 downto 0));
end component;
component SignExtend
port(x:in std_logic_vector(15 downto 0);y:out std_logic_vector(31 downto 0));
end component;
component ShiftLeft2
port(x:in std_logic_vector(31 downto 0);y:out std_logic_vector(31 downto 0));
end component;
component ShiftLeft2Jump
port(x:in std_logic_vector(3 downto 0);y:in std_logic_vector(25 downto 0);z:out std_logic_vector(31 downto 0));
end component;
component MUX5
port(x,y:in std_logic_vector (4 downto 0);
     sel:in std_logic;
     z:out std_logic_vector(4 downto 0));
end component;
component MUX32
port(x,y:in std_logic_vector (31 downto 0);
     sel:in std_logic;
     z:out std_logic_vector(31 downto 0));
end component;
component AND2
port(x,y:in std_logic;z:out std_logic);
end component;
signal clk2:std_logic;
signal Four:std_logic_vector(31 downto 0):=(2=>'1',others=>'0');
signal Add:std_logic_vector(3 downto 0):="0010";
signal Instruction:std_logic_vector(31 downto 0);
signal sigB:std_logic_vector(4 downto 0);
signal sigA,sigC,sigD,sigE,sigF,sigG,sigH,sigJ:std_logic_vector (31 downto 0);
signal sigK,sigL,sigM,sigN,sigP,sigQ:std_logic_vector (31 downto 0);
signal sigR:std_logic;
signal RegDst,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,Jump,Zero: std_logic;
signal ALUOp:std_logic_vector(1 downto 0);
signal Operation:std_logic_vector(3 downto 0);
begin
clk2<=clk after 1 ns;
RWR:registersWR port map(Instruction(25 downto 21),Instruction(20 downto 16),sigB,sigJ,clk,RegWrite,sigC,sigD);
IM:InstMemory port map(sigA,Instruction);
DMWR:DataMemoryWR port map(sigD,sigG,clk2,MemRead,MemWrite,sigH);
ALU1:ALU port map(sigC,sigF,Operation,sigG,Zero,Overflow);
ALU2:ALU port map(sigA,Four,Add,sigL,open,open);
ALU3:ALU port map(sigL,sigK,Add,sigM,open,open);
CTRL2:Control2 port map(Instruction(31 downto 26),RegDst,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,Jump,ALUOp);
ALUCTRL:ALUControl port map(ALUOp,Instruction(5 downto 0),Operation);
P1:PC2 port map(clk,sigP,sigA);
SE:SignExtend port map(Instruction(15 downto 0),sigE);
SL2:ShiftLeft2 port map(sigE,sigK);
SL2J:ShiftLeft2Jump port map(sigL(31 downto 28),Instruction(25 downto 0),sigQ);
M5:MUX5 port map(Instruction(20 downto 16),Instruction(15 downto 11),RegDst,sigB);
M321:MUX32 port map(sigD,sigE,ALUSrc,sigF);
M322:MUX32 port map(sigG,sigH,MemtoReg,sigJ);
A1:AND2 port map(Zero,Branch,sigR);
M323:MUX32 port map(sigL,sigM,sigR,sigN);
M324:MUX32 port map(sigN,sigQ,Jump,sigP);
end struc;
