-- IF Stage
-- Author:  Anshul Kharbanda
-- Created: 11 - 29 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- PC Stage entity
entity pc_stage is
    port (
        clk: in std_logic;
        branch_address: in std_logic_vector(31 downto 0);
        branch_command: in std_logic;
        pc: buffer std_logic_vector(31 downto 0);
        predicted_address: buffer std_logic_vector(31 downto 0);
        fallback_address: out std_logic_vector(31 downto 0)
    );
end entity;

-- Architecture of PC Stage
architecture arch of pc_stage is
    component btb_predictor is
        generic (
            n : natural := 32
        );
        port (
            clk: in std_logic;
            pc, next_address: in std_logic_vector(n-1 downto 0);
            branch: in std_logic;
            predicted_address,
            fallback_address: out std_logic_vector(n-1 downto 0)
        );
    end component;

    -- Declare signals
    signal delayed_clk : std_logic;
    signal d_pc : std_logic_vector(31 downto 0);
begin
    -- Delayed clk
    delayed_clk <= clk after 1 ns;

    -- Compute next pc
    d_pc <= branch_address when branch_command='1' else predicted_address;

    -- Branch target buffer predictor
    branch_target_buffer: btb_predictor
        generic map(
            n => 32
        )
        port map(
            clk => clk,
            pc => pc,
            next_address => d_pc,
            branch => branch_command,
            predicted_address => predicted_address,
            fallback_address => fallback_address
        );

    -- Program Counter
    pc <= d_pc when delayed_clk'event and delayed_clk='1' else pc;
end architecture;
