library IEEE;
use IEEE.STD_LOGIC_1164.ALL, IEEE.NUMERIC_STD.ALL;

entity registers is
    port(
        RR1, RR2, WR: in std_logic_vector(4 downto 0);
        WD, WS: in std_logic_vector(31 downto 0);  -- WS = Write Stack
        Clk, RegWrite: in std_logic;
	    StackOps: in std_logic_vector(1 downto 0);
        RD1, RD2: out std_logic_vector(31 downto 0)
    );
end registers;

architecture Behavioral of registers is
    -- Regfile signal
    type regFile_Type is array(0 to 31) of std_logic_vector(31 downto 0);
    signal regFile: regFile_Type;
begin
    process(RR1, RR2, WR, WD,WS, Clk, RegWrite)
        variable check_begin:boolean := true;
    begin

        -- Write register
        if clk='1' and clk'event then
        	if RegWrite = '1' then
        		if(not(WR = "00000") or not(WR="UUUUU")) then
        			regFile(to_integer(unsigned(WR))) <= WD;
        		end if;
        	end if;
        end if;

        -- Write stack
        if clk='0' and clk'event then
        	if StackOps(1)='1' then
        		regFile(to_integer(unsigned(RR1))) <= WS;
        	end if;
        end if;

        -- Read registers
    	RD1 <= regFile(to_integer(unsigned(RR1)));
    	RD2 <= regFile(to_integer(unsigned(RR2)));
    end process;
end Behavioral;
