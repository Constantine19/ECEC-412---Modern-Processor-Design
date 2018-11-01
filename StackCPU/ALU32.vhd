library ieee;
use ieee.std_logic_1164.all;
entity ALU32 is
generic( n : natural := 32);
port(a,b : in std_logic_vector(n-1 downto 0);
    Oper : in std_logic_vector(3 downto 0);
  Result : buffer std_logic_vector(n-1 downto 0);
Zero, Overflow : buffer std_logic);
end ALU32;

architecture struc of ALU32 is

component ALU1

port(a, b, Less, CarryIn : in std_logic;
Ainvert, Binvert, Op1, Op0: in std_logic;
Result, CarryOut, Set : out std_logic);

end component;

component NOR32

port (x : in std_logic_vector(31 downto 0);
      y : out std_logic);

end component;

signal Rip_Carry : std_logic_vector(n-1 downto 0);
signal Set31, Set31_to_Less : std_logic;

begin

G1: for i in 0 to n-1 generate

	G2: if i = 0 generate
	ALU0: ALU1 port map(a(i), b(i), Set31_to_Less, Oper(2), Oper(3), Oper(2), Oper(1), Oper(0), Result(i), Rip_Carry(i), open);
	end generate G2;

	G3: if i > 0 and i < n-1 generate
	ALUn: ALU1 port map(a(i), b(i), '0', Rip_Carry(i-1), Oper(3), Oper(2), Oper(1), Oper(0), Result(i), Rip_Carry(i), open);
	end generate G3;

	G4: if i = n-1 generate
	ALUn1: ALU1 port map(a(i), b(i), '0', Rip_Carry(i-1), Oper(3), Oper(2), Oper(1), Oper(0), Result(i), Rip_Carry(i), Set31);
	end generate G4;

end generate G1;

NOR_32 : NOR32 port map(Result, Zero);
overflow <= Rip_Carry(n-2) xor Rip_Carry(n-1);
Set31_to_Less <= Set31 xor Overflow;

end struc;
