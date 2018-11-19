-------------------------------- WRITABLE MEMORY -------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
    generic(
        wordlen : natural := 4;
        addrlen : natural := 32;
        memsize : natural := 256);
    port(
        clk : in std_logic;
        address : in std_logic_vector(addrlen-1 downto 0);
        wdata : in std_logic_vector(8*wordlen-1 downto 0);
        write : in std_logic;
        rdata : out std_logic_vector(8*wordlen-1 downto 0));
end entity;

architecture arch of memory is
    subtype byte is std_logic_vector(7 downto 0);
    type memarray is array (memsize downto 0) of byte;
    signal memory: memarray;
begin
    -- Write process
    write_process : process(clk)
        variable intaddr : integer;
    begin
        -- Convert address to integer
        intaddr := to_integer(unsigned(address));

        -- On write enable clock
        on_write_enable_clock : if clk'event and clk='1' and write='1' then
            write_bytes : for i in 0 to wordlen-1 loop
                memory(intaddr + (wordlen - i)) <= wdata(8*i+7 downto 8*i);
            end loop;
        end if;
    end process;

    -- Read process
    read_process : process(address)
        variable intaddr : integer;
    begin
        -- Convert address to integer
        intaddr := to_integer(unsigned(address));

        -- Read data
        read_bytes : for i in 0 to wordlen-1 loop
            rdata(8*i+7 downto 8*i) <= memory(intaddr + (wordlen - i));
        end loop;
    end process;
end architecture;

------------------------------- READ ONLY MEMORY -------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity romemory is
    generic(
        wordlen : natural := 4;
        addrlen : natural := 32;
        memsize : natural := 256);
    port(
        address : in std_logic_vector(addrlen-1 downto 0);
        data: out std_logic_vector(8*wordlen-1 downto 0));
end entity;

architecture arch of romemory is
    subtype byte is std_logic_vector(7 downto 0);
    type memarray is array (memsize downto 0) of byte;
    signal memory: memarray;
begin
    -- Write process
    read_process : process(address)
        variable intaddr : integer;
    begin
        -- Convert address to integer
        intaddr := to_integer(unsigned(address));

        -- Read data
        read_bytes : for i in 0 to wordlen-1 loop
            data(8*i+7 downto 8*i) <= memory(intaddr + (wordlen - i));
        end loop;
    end process;
end architecture;
