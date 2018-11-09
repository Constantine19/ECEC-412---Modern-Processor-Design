library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CPU is
	port(
		clk: in std_logic;
		Overflow: out std_logic);
end CPU;

architecture structure of CPU is
	-- Stage Components
	component IF_Stage is
		port(
			-- Inputs:
				-- CLK
				CLK: in std_logic;
			-- Outputs:
				-- Instruction
				Instruction: out std_logic_vector(31 downto 0);
				-- PC + 4
				PCPlus4: out std_logic_vector(31 downto 0)
		);
	end component;

	-- Signals
	signal
		Instruction,
		PCPlus4:
	std_logic_vector(31 downto 0);
begin

	-- IF Stage
	IFStage: IF_Stage
		port map(
			CLK=>clk,
			Instruction=>Instruction,
			PCPlus4=>PCPlus4
		);

end structure;
