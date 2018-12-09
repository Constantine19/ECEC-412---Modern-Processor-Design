-- ID Stage
-- Author:  Anshul Kharbanda
-- Created: 11 - 29 - 2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package helper is
    function not_equal(a,b: std_logic_vector) return std_logic;
end helper;

package body helper is
    function not_equal(a,b: std_logic_vector) return std_logic is
    begin
        if a = b then return '0';
        else return '1';
        end if;
    end not_equal;
end helper;
