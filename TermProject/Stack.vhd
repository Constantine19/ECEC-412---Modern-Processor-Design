library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity Stack is
port(input_instruction: in std_logic_vector(31 downto 0);
    stack_pointer: in std_logic_vector(31 downto 0);
    CLK: in std_logic;
    stack_pointer_out: out std_logic_vector(31 downto 0)
    pop_or_push: out std_logic;
    update_register: out std_logic_vector(31 downto 0)
end Stack;

architecture behav of Stack is
begin
    process(CLK) -- Passing sensetivity list
    begin
        if CLK='1' and CLK'event then
            if input_instruction = '110010' -- push corresponds to 50 in dec
                stack_pointer_out <= stack_pointer_out - 4; -- move stack pointer by one word (4-bytes)
                pop_or_push <= '1';
            else if input_instruction = '110011' -- pop corresponds to 51 in dec
                stack_pointer_out <= stack_pointer_out + 4;
                pop_or_push <= '0'; 
                update_register <= 










