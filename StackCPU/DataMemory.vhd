library IEEE;
use IEEE.STD_LOGIC_1164.ALL, IEEE.NUMERIC_STD.ALL;

entity DataMemory is
	port(WriteData:in std_logic_vector(31 downto 0);
			Address:in std_logic_vector(31 downto 0);
			MemRead,MemWrite,CLK:in std_logic;
			StackOps: in std_logic_vector(1 downto 0);
			ReadData:out std_logic_vector(31 downto 0));
end DataMemory;

architecture Behavioral of DataMemory is

type mem_type is array(0 to 255) of std_logic_vector(7 downto 0);
signal memFile: mem_type;

begin

process(WriteData, MemRead, MemWrite, CLK)
variable check_begin:boolean := true;

begin

if(check_begin) then
	memFile(4)<="00000000"; -- currently 4 00000000, -4 = 11111111, 11111100
	memFile(4+1)<="00000000"; -- currently 4, -4 = 11111100
	memFile(4+2)<="00000000"; -- currently 4, -4 = 11111100
	memFile(4+3)<="00000100"; -- currently 4 00000100, -4 = 11111100
	memFile(8)<="00000000"; -- currently 5, -5 = 11111011
	memFile(8+1)<="00000000"; -- currently 5, -5 = 11111011
	memFile(8+2)<="00000000"; -- currently 5, -5 = 11111011
	memFile(8+3)<="00000101"; -- currently 5 00000101, -5 = 11111011
	check_begin := false;
end if;
if CLK='1' and CLK'event then
	if (MemWrite = '1') and (MemRead = '0') then
		memFile(to_integer(unsigned(Address))) <= WriteData(31 downto 24);
		memFile(to_integer(unsigned(Address)) + 1) <= WriteData(23 downto 16);
		memFile(to_integer(unsigned(Address)) + 2) <= WriteData(15 downto 8);
		memFile(to_integer(unsigned(Address)) + 3) <= WriteData(7 downto 0);
	end if;
	if (MemWrite = '0') and (MemRead = '1') and StackOps/="10" then
		ReadData <= memFile(to_integer(unsigned(Address))) & memFile(to_integer(unsigned(Address)) + 1) & memFile(to_integer(unsigned(Address)) + 2) & memFile(to_integer(unsigned(Address)) + 3);
	end if;
end if;
if CLK='0' and CLK'event then
	if (MemWrite = '1') and (MemRead = '0') and StackOps/="11" then
		memFile(to_integer(unsigned(Address))) <= WriteData(31 downto 24);
		memFile(to_integer(unsigned(Address)) + 1) <= WriteData(23 downto 16);
		memFile(to_integer(unsigned(Address)) + 2) <= WriteData(15 downto 8);
		memFile(to_integer(unsigned(Address)) + 3) <= WriteData(7 downto 0);
	end if;
	if (MemWrite = '0') and (MemRead = '1') then
		ReadData <= memFile(to_integer(unsigned(Address))) & memFile(to_integer(unsigned(Address)) + 1) & memFile(to_integer(unsigned(Address)) + 2) & memFile(to_integer(unsigned(Address)) + 3);
	end if;
end if;
end process;

end Behavioral;
