library ieee;
use ieee.std_logic_1164.all;
entity ALU_1bit is
port(a,b,less,CarryIn:in std_logic;
     Ainvert,Binvert,Op1,Op0:in std_logic;
     Result,CarryOut,set:out std_logic);
 end ALU_1bit;
 
 architecture behav of ALU_1bit is
 begin
 process(a,b,less,CarryIn,Ainvert,Binvert,Op1,Op0)
 variable ALUControl:std_logic_vector(3 downto 0); 
 begin
 ALUControl:=Ainvert&Binvert&Op1&Op0;
 case ALUControl is
 when "0000"=>
 Result<=a and b;
 when "0001"=>
 Result<=a or b;
 when "0010"=>
 Result<=a xor b xor CarryIn;
 CarryOut<=(a and b)or(a and CarryIn)or(b and CarryIn);
 when "0110"=>
 Result<=a xor (not b) xor CarryIn;
 CarryOut<=(a and not b)or(a and CarryIn)or(not b and CarryIn);
 when "0111"=>
 set<=a xor not b xor CarryIn;
 CarryOut<=(a and not b)or(a and CarryIn)or(not b and CarryIn);
 Result<=less;
 when "1100"=>
 Result<=(not a) and (not b);
 when others=>
 Result<='U';
 CarryOut<='U';
 set<='U';
 end case;
 end process;
 end behav;
 
 
 
 
 
     
     
     