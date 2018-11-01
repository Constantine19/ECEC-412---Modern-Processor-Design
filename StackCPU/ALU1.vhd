library IEEE;
use ieee.std_logic_1164.all;

entity ALU1 is
port(a, b, Less, CarryIn : in std_logic;
Ainvert, Binvert, Op1, Op0: in std_logic;
Result, CarryOut, Set : out std_logic);
end ALU1;

architecture behav of ALU1 is

begin

process(a,b,Less,CarryIn,Ainvert,Binvert,Op1,Op0)
variable control: std_logic_vector(3 downto 0);

begin

control := Ainvert & Binvert & Op1 & Op0;

case control is
	when "0000" =>
		Result <= a and b;
	when "0001" =>
		Result <= a or b;
	when "0010" =>
		Result <= a xor b xor CarryIn;
		CarryOut <= (a and b) or (a and CarryIn) or (b and CarryIn);
	when "0110" =>
		Result <= a xor (not b) xor Carryin;
		CarryOut <= (a and (not b)) or (a and CarryIn) or ((not b) and CarryIn);
	when "0111" =>
		Set <= a xor (not b) xor CarryIn;
		CarryOut <= (a and (not b)) or (a and CarryIn) or ((not b) and CarryIn);
		Result <= Less;
	when "1100" =>
		Result <= (not a) and (not b);
	when others =>
		Result <= 'U';
		CarryOut <= 'U';
		Set <= 'U';
end case;
end process;
end behav;