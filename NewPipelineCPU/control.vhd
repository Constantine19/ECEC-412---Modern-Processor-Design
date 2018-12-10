-- ID Stage
-- Author:  Anshul Kharbanda
-- Created: 11 - 29 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is
    port (
        opcode: in std_logic_vector(5 downto 0);
        aluop: out std_logic_vector(2 downto 0);
        regsrc, jump,
        alusrc, branch,
        memwrite, mem2reg,
        regwrite,
        stackop,
        stackpushpop : out std_logic
    );
end entity;

architecture arch of control is
begin
    main_selector_process: process(opcode)
    begin
        case(opcode) is
            when "000000" => -- ALU-OP
                regsrc <= '0'; -- 3-address (r-type)
                alusrc <= '0';
                aluop <= "100"; -- Use ALU
                branch <= 'X'; -- No Branch
                jump <= '0'; -- No Jump
                memwrite <= '0'; -- No Memory operations
                mem2reg <= '0';
                regwrite <= '1'; -- Writing reguster
                stackop <= '0'; -- No stack operations
                stackpushpop <= 'X';
            when "001000" => -- ADD Immediate
                regsrc <= '1'; -- 2-address (i-type)
                alusrc <= '1';
                aluop <= "110"; -- Use ALU (adding)
                branch <= 'X'; -- No Branch
                jump <= '0'; -- No Jump
                memwrite <= '0'; -- No Memory operations
                mem2reg <= '0';
                regwrite <= '1'; -- Writing reguster
                stackop <= '0'; -- No stack operations
                stackpushpop <= 'X';
            when "100011" => -- LW
                regsrc <= '1'; -- 2-address (i-type)
                alusrc <= '1';
                aluop <= "110"; -- Use ALU (adding)
                branch <= 'X'; -- No Branch
                jump <= '0'; -- No Jump
                memwrite <= '0'; -- Read memory
                mem2reg <= '1';
                regwrite <= '1'; -- Writing reguster
                stackop <= '0'; -- No stack operations
                stackpushpop <= 'X';
            when "101011" => -- SW
                regsrc <= '1'; -- 2-address (i-type)
                alusrc <= '1';
                aluop <= "110"; -- Use ALU (adding)
                branch <= 'X'; -- No Branch
                jump <= '0'; -- No Jump
                memwrite <= '1'; -- Writing memory
                mem2reg <= '0';
                regwrite <= '0'; -- No writing reguster
                stackop <= '0'; -- No stack operations
                stackpushpop <= 'X';
            when "000100" => -- Branch eq
                regsrc <= '1'; -- 2-address (i-type)
                alusrc <= '1';
                aluop <= "101"; -- Use ALU (subbung)
                branch <= '1'; -- Branch
                jump <= '0'; -- No Jump
                memwrite <= '0'; -- No Writing memory
                mem2reg <= '0';
                regwrite <= '0'; -- No writing reguster
                stackop <= '0'; -- No stack operations
                stackpushpop <= 'X';
            when "000010" => -- Jump
                regsrc <= '0'; -- 3-address (j-type)
                alusrc <= '0';
                aluop <= "000"; -- Do NOT Use ALU
                branch <= 'X'; -- No Branch
                jump <= '1'; -- Jump
                memwrite <= '0'; -- No Writing memory
                mem2reg <= '0';
                regwrite <= '0'; -- No writing reguster
                stackop <= '0'; -- No stack operations
                stackpushpop <= 'X';
            when others => -- NO-OP
                regsrc <= '0'; -- 3-address (r-type)
                alusrc <= '0';
                aluop <= "000"; -- Do Not Use ALU
                branch <= 'X'; -- No Branch
                jump <= '0'; -- No Jump
                memwrite <= '0'; -- Writing memory
                mem2reg <= '0';
                regwrite <= '0'; -- No writing reguster
                stackop <= '0'; -- No stack operations
                stackpushpop <= 'X';
        end case;
    end process;
end architecture;
