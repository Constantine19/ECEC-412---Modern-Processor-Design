library IEEE;
use IEEE.STD_LOGIC_1164.ALL, IEEE.NUMERIC_STD.ALL;

entity DataMemory is
	port(
		WriteData: in std_logic_vector(31 downto 0);
		Address: in std_logic_vector(31 downto 0);
		MemRead, MemWrite, CLK: in std_logic;
		ReadData: out std_logic_vector(31 downto 0)
	);
end DataMemory;

architecture Behavioral of DataMemory is
	-- Memory array
	type mem_type is array(0 to 255) of std_logic_vector(7 downto 0);
	signal memFile: mem_type;
begin
	process(WriteData, MemRead, MemWrite, CLK)
	begin
		if CLK='1' and CLK'event then
			-- Write memory
			if (MemWrite = '1') and (MemRead = '0') then
				memFile(to_integer(unsigned(Address))) <= WriteData(31 downto 24);
				memFile(to_integer(unsigned(Address)) + 1) <= WriteData(23 downto 16);
				memFile(to_integer(unsigned(Address)) + 2) <= WriteData(15 downto 8);
				memFile(to_integer(unsigned(Address)) + 3) <= WriteData(7 downto 0);
			end if;

			-- Read memory
			if (MemWrite = '0') and (MemRead = '1') then
				ReadData(31 downto 24) <= memFile(to_integer(unsigned(Address)));
				ReadData(23 downto 16) <= memFile(to_integer(unsigned(Address)) + 1);
				ReadData(15 downto 8) <= memFile(to_integer(unsigned(Address)) + 2);
				ReadData(7 downto 0) <= memFile(to_integer(unsigned(Address)) + 3);
			end if;
		end if;
	end process;
end Behavioral;
