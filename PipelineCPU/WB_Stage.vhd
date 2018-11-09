-- MIPS 32 CPU Pipeline Arch
-- Author:  Anshul Kharbanda
-- Created: 11 - 1 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity WB_Stage is
    port(
        -- CLK
        CLK: in std_logic;
        -- ALUResult
        ALUResult, MemReadData: in std_logic_vector(31 downto 0);
        -- MemtoReg
        MemtoReg, RegWrite: in std_logic;
        -- RegWriteData/StackWrite
        RegWriteData, StackWrite: out std_logic_vector(31 downto 0)
    );
end WB_Stage;

architecture arch of WB_Stage is
    -- Components
    component reg1 is
        port(
            clk: in std_logic;
            x: in std_logic;
            y: out std_logic
        );
    end component;
	component reg is
		generic (n: natural := 32);
		port(
			clk: in std_logic;
			x: in std_logic_vector(n-1 downto 0);
			y: out std_logic_vector(n-1 downto 0)
		);
	end component;
    component mux is
		generic (n: natural := 32);
		port (
	        x: in std_logic_vector(n-1 downto 0);
	        y: in std_logic_vector(n-1 downto 0);
	        sel: in std_logic;
	        z: out std_logic_vector(n-1 downto 0)
	    );
	end component;

    -- Signals
    signal RegWriteDataSignal: std_logic_vector(31 downto 0);
begin
    -- Write Back
	MuxForWriteBackData: mux
		generic map(32)
		port map(
			x=>AluResult,
			y=>MemReadData,
			sel=>MemtoReg,
			z=>RegWriteDataSignal);
    RegWriteDataReg: reg generic map(32) port map(CLK, RegWriteDataSignal, RegWriteData)
    StackWriteReg: reg generic map(32) port map(CLK, AluResult, StackWrite)
end arch;
