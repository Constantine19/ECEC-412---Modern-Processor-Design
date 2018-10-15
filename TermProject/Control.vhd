library ieee;
use ieee.std_logic_1164.all;
entity Control2 is
port(Opcode:in std_logic_vector(5 downto 0);
     RegDst,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,Jump:out std_logic;
     ALUOp:out std_logic_vector(1 downto 0));
end Control2;
architecture behav of Control2 is
begin
process(Opcode)
variable temp:std_logic_vector(8 downto 0);
begin
if Opcode="000000" then
temp:="100100010";
elsif Opcode="100011" then
temp:="011110000";
elsif Opcode="101011" then
temp:="U1U001000";
elsif Opcode="000100" then
temp:="U0U000101";
end if;
RegDst<=temp(8);
ALUSrc<=temp(7);
MemtoReg<=temp(6);
RegWrite<=temp(5);
MemRead<=temp(4);
MemWrite<=temp(3);
Branch<=temp(2);
ALUOp<=temp(1 downto 0);
if Opcode="000010" then
  Jump<='1';
else
  Jump<='0';
  end if;
end process;
end behav;
