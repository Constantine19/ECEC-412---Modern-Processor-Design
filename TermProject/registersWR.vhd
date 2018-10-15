library ieee;
use ieee.std_logic_1164.all,ieee.std_logic_arith.all;
entity registersWR is
  port(RR1,RR2,WR:in std_logic_vector(4 downto 0);
       WD:in std_logic_vector(31 downto 0);
       CLK,RegWrite:in std_logic;
       RD1,RD2:out std_logic_vector(31 downto 0));
end registersWR;

architecture behav of registersWR is
type twodarray is array(0 to 31) of std_logic_vector(31 downto 0);
signal regcontents:twodarray;
begin
  process(CLK)
      variable i,j,k:integer;
      variable flag:boolean:=FALSE;
      begin
        if flag=FALSE then
        -- Initialize $zero=0,$t0=0,$s4=14,$s5=5,$s6=8,$s7=3
        regcontents(0)<=(others=>'0');
        regcontents(8)<=(others=>'0');
        regcontents(20)<="00000000000000000000000000001110";
        regcontents(21)<="00000000000000000000000000000101";
        regcontents(22)<="00000000000000000000000000001000";
        regcontents(23)<="00000000000000000000000000000011";
        flag:=TRUE;
      end if;
        i:=conv_integer(unsigned(RR1));
       j:=conv_integer(unsigned(RR2));
       k:=conv_integer(unsigned(WR));
       if CLK='0' then
       RD1<=regcontents(i);
      RD2<=regcontents(j);
       elsif CLK='1' and RegWrite='1' and k/=0 then
         regcontents(k)<=WD;
       end if;
    end process;
   end behav;
