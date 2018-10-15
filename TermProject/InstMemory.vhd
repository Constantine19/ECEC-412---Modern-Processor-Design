library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
entity InstMemory is
port(Address:in std_logic_vector(31 downto 0);
     ReadData:out std_logic_vector(31 downto 0));
end InstMemory;

architecture behav of InstMemory is
type memarray is array(0 to 2**8-1) of std_logic_vector(7 downto 0);
signal memcontents:memarray;
begin
process(Address)
 variable i,j:integer;
begin 
  -- instructions follow
  -- lw $s0,0($t0)
  memcontents(0)<="10001101";
    memcontents(1)<="00010000";
    memcontents(2)<="00000000";
    memcontents(3)<="00000000";
    -- lw $s1,4($t0)
    memcontents(4)<="10001101";
  memcontents(5)<="00010001";
  memcontents(6)<="00000000";
  memcontents(7)<="00000100";
  -- beq $s0,$s1,L
memcontents(8)<="00010010";
    memcontents(9)<="00010001";
    memcontents(10)<="00000000";
    memcontents(11)<="00000010";
    -- add $s3,$s4,$s5
    memcontents(12)<="00000010";
  memcontents(13)<="10010101";
  memcontents(14)<="10011000";
  memcontents(15)<="00100000";
  -- j exit
   memcontents(16)<="00001000";
    memcontents(17)<="00000000";
    memcontents(18)<="00000000";
    memcontents(19)<="00000110";
    -- sub $s3,$s4,$s5
    memcontents(20)<="00000010";
  memcontents(21)<="10010101";
  memcontents(22)<="10011000";
  memcontents(23)<="00100010";
  --exit: sw $s3,8($t0)
memcontents(24)<="10101101";
    memcontents(25)<="00010011";
    memcontents(26)<="00000000";
    memcontents(27)<="00001000";
j:=conv_integer(unsigned(Address));
ReadData<=memcontents(j)& memcontents(j+1) & memcontents(j+2) & memcontents(j+3);
end process;
end behav;

