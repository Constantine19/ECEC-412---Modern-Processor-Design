library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity ALUControl is
port(ALUOp:in std_logic_vector(1 downto 0);
     Funct:in std_logic_vector(5 downto 0);
     Operation:out std_logic_vector(3 downto 0));
end ALUControl;

architecture behav of ALUControl is

begin

process(ALUOp, Funct)
begin

if ALUOp="00" then
Operation<="0010"; --LW, SW

elsif ALUOp="01" then
Operation<="0110"; --BEQ

elsif ALUOp="10" then -- R-format

	if Funct="100000" then
	Operation<="0010"; -- Add
	
	elsif Funct="100010" then
	Operation<="0110";-- Sub
	
	elsif Funct="100100" then
	Operation<="0000"; -- AND
	
	elsif Funct="100101" then
	Operation<="0001"; -- OR
	
	elsif Funct="101010" then
	Operation<="0111"; -- SLT

	else
	Operation<="UUUU";
	
	end if;

else
	Operation<="UUUU";

end if;
end process;
end behav;	
