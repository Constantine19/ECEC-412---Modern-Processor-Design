library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
entity DataMemoryWR is
port(WriteData:in std_logic_vector(31 downto 0);
     Address:in std_logic_vector(31 downto 0);
     CLK,MemRead,MemWrite:in std_logic;
     ReadData:out std_logic_vector(31 downto 0));
end DataMemoryWR;

architecture behav of DataMemoryWR is
type memarray is array(0 to 2**8-1) of std_logic_vector(7 downto 0);
signal memcontents:memarray;
begin
process(CLK)
variable i,j:integer;
variable flag:boolean:=FALSE;
begin
  if flag=FALSE then
memcontents(0)<="00000000";
memcontents(1)<="00000000";
memcontents(2)<="00000000";
memcontents(3)<="00000101";
memcontents(4)<="00000000";
memcontents(5)<="00000000";
memcontents(6)<="00000000";
memcontents(7)<="00000100";
flag:=TRUE;
end if;
j:=conv_integer(unsigned(Address));
if CLK='0' and MemRead='1' and Address/="UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU" then
ReadData<=memcontents(j)& memcontents(j+1) & memcontents(j+2) & memcontents(j+3);
end if;
if CLK='1' and MemWrite='1' and Address/="UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU" then
  
   memcontents(j)<=WriteData(31 downto 24);
   memcontents(j+1)<=WriteData(23 downto 16);
   memcontents(j+2)<=WriteData(15 downto 8);
   memcontents(j+3)<=WriteData(7 downto 0);
 end if;
 end process;
end behav;

