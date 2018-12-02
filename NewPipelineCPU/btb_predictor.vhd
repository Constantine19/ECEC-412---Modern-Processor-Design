-- Branch Target Buffer Predictor
-- Author:  Anshul Kharbanda
-- Created: 11 - 29 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity btb_predictor is
    generic (
        n : natural := 32
    );
    port (
        clk: in std_logic;
        pc, next_address: in std_logic_vector(n-1 downto 0);
        branch: in std_logic;
        predicted_address, fallback_address: out std_logic_vector(n-1 downto 0)
    );
end entity;

architecture arch of btb_predictor is
    -- Table entity
    component table is
        generic(
            addr_size: natural := 32;
            value_size: natural := 33;
            table_size: natural := 32
        );
        port(
            clk: in std_logic;
            addr: in std_logic_vector(addr_size-1 downto 0);
            wvalue: in std_logic_vector(value_size-1 downto 0);
            write: in std_logic;
            rvalue: out std_logic_vector(value_size-1 downto 0)
        );
    end component;
    component alu is
        generic (
            n: natural := 32
        );
        port (
            a, b: in std_logic_vector(n-1 downto 0);
            oper: in std_logic_vector(3 downto 0);
            res: buffer std_logic_vector(n-1 downto 0);
            zero, overflow: buffer std_logic
        );
    end component;

    -- Declare signals
    signal
        write_value,
        read_value:
    std_logic_vector(32 downto 0);
    signal
        buffer_address,
        pcplus4:
    std_logic_vector(31 downto 0);
    signal
        hit:
    std_logic;

    -- Declare constnats
    constant four : std_logic_vector(31 downto 0) := (2=>'1', others=>'0');
    constant add : std_logic_vector(3 downto 0) := "0010";
begin
    -- Computes entry in branch table
    write_value(32) <= '1';
    write_value(31 downto 0) <= next_address;

    -- Branch table
    branch_table: table
        generic map(
            addr_size => 32,
            value_size => 33,
            table_size => 2**16
        )
        port map(
            clk => clk,
            addr => pc,
            wvalue => write_value,
            write => branch,
            rvalue => read_value
        );

    -- Split result
    hit <= read_value(32);
    buffer_address <= read_value(31 downto 0);

    -- Compute pc plus 4
    pc_add: alu generic map(32) port map(pc, four, add, pcplus4, open, open);

    -- Predicted and fallback addresses
    predicted_address <= buffer_address when hit='1' else pcplus4;
    fallback_address <= pcplus4;
end architecture;
