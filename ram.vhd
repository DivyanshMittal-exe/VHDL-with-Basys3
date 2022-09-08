library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_mem is
    port (
        clk : in std_logic;
        we    : in std_logic;

        addr : in std_logic_vector(7 downto 0);
        din    : in std_logic_vector(7 downto 0);
        dout    : out std_logic_vector(7 downto 0)

    );
end data_mem;

architecture arch of data_mem is
    type mem is array(0 to 511) of std_logic_vector(7 downto 0);
    signal data : mem := (
        others => X"00"
    );
begin
    dout <= data(to_integer(unsigned(addr)));

    write : process (clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                data(to_integer(unsigned(addr))) <= din;
            end if ;
        end if;
    end process;      -- write
end architecture; 