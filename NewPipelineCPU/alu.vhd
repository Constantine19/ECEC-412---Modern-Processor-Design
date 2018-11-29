-- ALU Component
-- Author:  Anshul Kharbanda
-- Created: 11 - 27 - 2018
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
---------------------------------- ALU 1-bit -----------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Entity alu1
entity alu1 is
    port(
        a, b, cin, less: in std_logic;
        oper: in std_logic_vector(3 downto 0);
        res, cout, set: out std_logic
    );
end entity;

-- Architecture of alu1
architecture arch of alu1 is
    -- Components
    component add1 is
        port(
            a, b, cin: in std_logic;
            sum, cout: out std_logic
        );
    end component;

    -- Signals
    signal atrue, btrue, sum: std_logic;
begin
    -- Map true values
    atrue <= not a when oper(3)='1' else a;
    btrue <= not b when oper(2)='1' else b;

    -- Map adder signals
    sum <= a xor b xor cin;
    cout <= (a and b) or (a and cin) or (b and cin);

    -- Selector process
    select_res: process(oper, atrue, btrue)
    begin
        case (oper(1 downto 0)) is
            when "00" => -- AND
                res <= atrue and btrue;
                set <= 'U';
            when "01" => -- OR
                res <= atrue or btrue;
                set <= 'U';
            when "10" => -- ADD/SUB
                res <= sum;
                set <= 'U';
            when "11" => -- SLT
                res <= less;
                set <= sum;
            when others =>
                res <= 'U';
                set <= 'U';
        end case;
    end process;
end architecture;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
---------------------------------- ALU N-Bit -----------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Entity of N-bit ALU
entity alu is
    generic (
        n: natural := 32
    );
    port (
        a, b: in std_logic_vector(n-1 downto 0);
        oper: in std_logic_vector(3 downto 0);
        res: out std_logic_vector(n-1 downto 0)
    );
end entity;

-- Architecture of N-bit ALU
architecture arch of alu is
    -- Declare components
    component alu1 is
        port(
            a, b, cin, less: in std_logic;
            oper: in std_logic_vector(3 downto 0);
            res, cout, set: out std_logic
        );
    end component;

    -- Declare signals
    signal c: std_logic_vector(n downto 0);
    signal set31: std_logic;
begin
    -- Set first carry to binv (indicating subtract)
    c(0) <= oper(2);

    -- Generate alus
    alu0: alu1 port map(a(0), b(0), c(0), set31, oper, res(0), c(1), open);
    gen_alus_in_between : for i in 1 to n-2 generate
        alui: alu1 port map(a(i), b(i), c(i), '0', oper, res(i), c(i+1), open);
    end generate;
    aluN: alu1 port map(a(n-1), b(n-1), c(n-1), '0', oper, res(n-1), c(n), set31);
end architecture;
