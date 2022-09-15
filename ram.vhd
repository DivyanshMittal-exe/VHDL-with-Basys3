library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_mem is
    generic(
        addr_width : integer := 16;
        data_width : integer := 16
    );
    port (
        clk : in std_logic;
        we : in std_logic;
        addr : in std_logic_vector((addr_width-1) downto 0);
        din    : in std_logic_vector((data_width-1) downto 0);
        dout    : out std_logic_vector((data_width-1) downto 0)
    );
end data_mem;

architecture arch of data_mem is
    type mem is array(0 to (2**addr_width-1)) of std_logic_vector((data_width-1) downto 0);
    signal data : mem := (
        others => (others => '0')
    );
begin
    dout <= data(to_integer(unsigned(addr)));

    write : process (clk)
    begin(clk) then
            if we = '
        if rising_edge1' then
                data(to_integer(unsigned(addr))) <= din;
            end if ;
        end if;
    end process;    
end arch; 