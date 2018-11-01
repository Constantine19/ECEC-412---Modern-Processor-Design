library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CPU is
port(clk:in std_logic; Overflow:out std_logic);
end CPU;

architecture structure of CPU is

-- Declaring each component

component PC is
port(clk:in std_logic;
AddressIn:in std_logic_vector(32-1 downto 0);
AddressOut:out std_logic_vector(32-1 downto 0));
end component;

component SignExtend is
port(x:in std_logic_vector(16-1 downto 0);
	y:out std_logic_vector(16*2-1 downto 0));
end component;

component ShiftLeft2 is
port(x:in std_logic_vector(32-1 downto 0);
	y:out std_logic_vector(32-1 downto 0));
end component;

component ShiftLeft2Jump is
port(x:in std_logic_vector(3 downto 0);
	y:in std_logic_vector(32-7 downto 0);
	z:out std_logic_vector(32-1 downto 0));
end component;

component mux5 is
port(x,y:in std_logic_vector (4 downto 0);
	sel:in std_logic;
	z:out std_logic_vector(4 downto 0));
end component;

component mux32 is
Port (x,y:in STD_LOGIC_VECTOR(31 downto 0);
	sel:in STD_LOGIC;
	z: out  STD_LOGIC_VECTOR(31 downto 0));
end component;

component And2 is
port (x,y: in std_logic;
	z:out std_logic);
end component;

component ALU32 is
generic(n:natural:=32);
port(a,b:in std_logic_vector(n-1 downto 0);
	Oper:in std_logic_vector(3 downto 0);
	Result:buffer std_logic_vector(n-1 downto 0);
	Zero,Overflow:buffer std_logic);
end component;

component registers is
  port(RR1,RR2,WR:in std_logic_vector(4 downto 0);
       WD,WS:in std_logic_vector(31 downto 0); 
       Clk,RegWrite:in std_logic;
	StackOps: in std_logic_vector(1 downto 0);
       RD1,RD2:out std_logic_vector(31 downto 0));
end component;

component InstMemory is
port(Address:in std_logic_vector(31 downto 0);
	ReadData:out std_logic_vector(31 downto 0));
end component;

component DataMemory is
port(WriteData:in std_logic_vector(31 downto 0);
	Address:in std_logic_vector(31 downto 0);
	MemRead,MemWrite,CLK:in std_logic;
	StackOps:in std_logic_vector(1 downto 0);
	ReadData:out std_logic_vector(31 downto 0));
end component;

component ALUControl is
port(ALUOp:in std_logic_vector(1 downto 0);
	Funct:in std_logic_vector(5 downto 0);
	Operation:out std_logic_vector(3 downto 0));
end component;

component Control is
port(Opcode: in std_logic_vector(5 downto 0);
	RegDst, Branch, MemRead, MemtoReg : out std_logic;
	ALUSrc, RegWrite, Jump, MemWrite  : out std_logic;
	ALUOp,StackOps: out std_logic_vector(1 downto 0));
end component;

component MUX32_2 is
port(x,y:in std_logic_vector (31 downto 0);
     sel:in std_logic_vector(1 downto 0);
     z:out std_logic_vector(31 downto 0));
end component;

component MUX32_4 is 
port(w,v,x,y:in std_logic_vector (31 downto 0);
     sel:in std_logic_vector(1 downto 0);
     z:out std_logic_vector(31 downto 0));
end component;

--Declare Signals based on Single Cycle CPU
signal instruction,A,C,D,E,F,G,H,J,K,L,M,N,P,Q,Y,X,V:std_logic_vector(31 downto 0);

signal B:std_logic_vector(4 downto 0);
signal R:std_logic;
signal RegDst,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,Jump,Zero,clk2:std_logic;
signal ALUOp,StackOps:std_logic_vector(1 downto 0);
signal operation: std_logic_vector(3 downto 0);
signal four:std_logic_vector(31 downto 0):="00000000000000000000000000000100";
signal neg_four:std_logic_vector(31 downto 0):="11111111111111111111111111111100";
begin

clk2<= clk after 1 ns;

--Start 
PC1:PC port map(clk=>clk,AddressIn=>P,AddressOut=>A);
InstMem: InstMemory port map(Address=>A,ReadData=>instruction);
Add4: ALU32 port map(a=>A,b=>four,Oper=>"0010",Result=>L,Zero=>open,Overflow=>open);
Control1: Control port map(Opcode=>instruction(31 downto 26),RegDst=>RegDst,Branch=>Branch,MemRead=>MemRead,MemtoReg=>MemtoReg,MemWrite=>MemWrite,ALUSrc=>ALUSrc,RegWrite=>RegWrite,Jump=>Jump,ALUOp=>ALUOp,StackOps=>StackOps);
Mux1:mux5 port map(x=>instruction(20 downto 16),y=>instruction(15 downto 11),sel=>RegDst,z=>B);
Register1:registers port map(RR1=>instruction(25 downto 21),RR2=>instruction(20 downto 16),WR=>B,WD=>J,RegWrite=>RegWrite,StackOps=>StackOps,Clk=>clk,RD1=>C,RD2=>D,WS=>G);
SignExtend1:SignExtend port map(instruction(15 downto 0),E);
Mux2:mux32 port map(D,E,ALUSrc,F);
ALUControl1:ALUControl port map(ALUOp,instruction(5 downto 0),operation);
ALU1:ALU32 port map(C,Y,operation,G,Zero,open);
Shift1:ShiftLeft2 port map(E,K);
AddALU:ALU32 port map(L,K,"0010",M,open,open);
ShiftJump:ShiftLeft2Jump port map(L(31 downto 28),instruction(25 downto 0),Q);
And1:And2 port map(Branch,Zero,R);
Mux3:mux32 port map(L,M,R,N);
DMemory:DataMemory port map(X,V,MemRead,MemWrite,clk2,StackOps,H);
Mux4:mux32 port map(G,H,MemtoReg,J);
Mux55:mux32 port map(N,Q,Jump,P);
Mux6:mux32 port map(D,E,StackOps(0),X);
Mux32_21:MUX32_2 port map(G,C,StackOps,V);
Mux32_41:MUX32_4 port map(F,F,four,neg_four,StackOps,Y);

end structure;
