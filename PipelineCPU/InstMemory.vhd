library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstMemory isport(Address:in std_logic_vector(31 downto 0);     ReadData:out std_logic_vector(31 downto 0));end InstMemory;

architecture Behavioral of InstMemory is

type mem_type is array(0 to 256) of std_logic_vector(7 downto 0);
signal memArray: mem_type;

begin
process(Address) 
variable check_begin:boolean:=true;
begin
if (check_begin) then
-- set up memory with converted assembly code. 8 total instructions.
-- lw $s5, 0($t0) 0x8d150000
memArray(0)<="10001101";-- correct
memArray(1)<="00010101";-- correct
memArray(2)<="00000000";-- correct
memArray(3)<="00000000";-- correct
-- lw $s6, 4($t0) 0x8d160004
memArray(4)<="10001101";-- correct
memArray(5)<="00010110";-- correct
memArray(6)<="00000000";-- correct
memArray(7)<="00000100";-- correct
-- slt $t7,$s5,$s6 0x02b6782a
memArray(8)<="00000010";-- correct
memArray(9)<="10110110";-- correct
memArray(10)<="01111000";-- correct
memArray(11)<="00101010";-- correct
-- beq $t7,$zero,L 0x11e00002
memArray(12)<="00010001";-- correct
memArray(13)<="11100000";-- correct
memArray(14)<="00000000";-- correct
memArray(15)<="00000010";-- correct
-- sub $s1,$s2,$3 0x02438822
memArray(16)<="00000010";-- correct
memArray(17)<="01010011";-- correct
memArray(18)<="10001000";-- correct
memArray(19)<="00100010";-- correct
-- j exit 0x08000007
memArray(20)<="00001000";-- correct
memArray(21)<="00000000";-- correct
memArray(22)<="00000000";-- correct
memArray(23)<="00000111";-- correct
-- L: add $s1,$s2,$s3 0x02538820
memArray(24)<="00000010";-- correct
memArray(25)<="01010011";-- correct
memArray(26)<="10001000";-- correct
memArray(27)<="00100000";-- correct
--exit: sw $s1,12($t0) 0xad11000c
memArray(28)<="10101101";-- correct
memArray(29)<="00010001";-- correct
memArray(30)<="00000000";-- correct
memArray(31)<="00001100";-- correct

check_begin:=false;


end if;
ReadData<=memArray(to_integer(unsigned(Address))) & memArray(to_integer(unsigned(Address))+1) & memArray(to_integer(unsigned(Address))+2) & memArray(to_integer(unsigned(Address))+3);
end process;
end Behavioral;