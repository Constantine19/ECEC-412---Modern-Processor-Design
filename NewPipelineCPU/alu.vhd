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
-- TODO: Determine error with initial result
architecture arch of alu1 is
begin
    select_operation : process(oper, a, b, cin, less)
    begin
        case oper is
            when "0000" => -- AND
                res <= a and b;
                set <= 'U';
            when "0001" => -- OR
                res <= a or b;
                set <= 'U';
            when "0010" => -- ADD
                res <= a xor b xor cin;
                cout <= (a and b) or (a and cin) or (b and cin);
                set <= 'U';
            when "0110" => -- SUB
                res <= a xor (not b) xor cin;
                cout <= (a and (not b)) or (a and cin) or ((not b) and cin);
            when "0111" => -- SLT
                set <= a xor (not b) xor cin;
                cout <= (a and (not b)) or (a and cin) or ((not b) and cin);
                res <= less;
            when others =>
                res <= 'U';
                cout <= 'U';
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
        res: buffer std_logic_vector(n-1 downto 0);
        zero, overflow: buffer std_logic
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
    signal l31, l0: std_logic;
begin
    -- Set first carry to binv (indicating subtract)
    c(0) <= oper(2);

    -- Generate alus
    alu0 : alu1 port map(a(0), b(0), c(0), l0, oper, res(0), c(1), open);
    gen_alus_in_between : for i in 1 to n-2 generate
        alui : alu1 port map(a(i), b(i), c(i), '0', oper, res(i), c(i+1), open);
    end generate;
    aluN : alu1 port map(a(n-1), b(n-1), c(n-1), '0', oper, res(n-1), c(n), l31);

    -- Compute zero
    zero_reduce : process(res)
        variable temp : std_logic;
    begin
        temp := '0';
        identifier: for i in res'range loop
            temp := temp or res(i);
        end loop;
        zero <= not temp;
    end process;

    -- Compute overflow
    overflow <= c(n) xor c(n-1);

    -- Wire 31-bit less value (or overflow) back around to 0-bit less value
    l0 <= l31 xor overflow;
end architecture;
