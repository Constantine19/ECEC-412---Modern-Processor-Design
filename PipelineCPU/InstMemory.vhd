library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstMemory is
    port(
        Address:in std_logic_vector(31 downto 0);
        ReadData:out std_logic_vector(31 downto 0));
end InstMemory;

architecture Behavioral of InstMemory is

type mem_type is array(0 to 256) of std_logic_vector(7 downto 0);
signal memFile: mem_type;

begin
    process(Address)
    begin
        ReadData <= memFile(to_integer(unsigned(Address)))
                  & memFile(to_integer(unsigned(Address)) + 1)
                  & memFile(to_integer(unsigned(Address)) + 2)
                  & memFile(to_integer(unsigned(Address)) + 3);
    end process;
end Behavioral;
