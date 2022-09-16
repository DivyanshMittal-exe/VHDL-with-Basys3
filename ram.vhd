library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_mem is
    generic (
        addr_width : integer := 16;
        data_width : integer := 16
    );
    port (
        clk  : in std_logic;
        we   : in std_logic;
        re   : in std_logic;
        addr : in std_logic_vector((addr_width - 1) downto 0);
        din  : in std_logic_vector((data_width - 1) downto 0);
        dout : out std_logic_vector((data_width - 1) downto 0)
    );
end data_mem;

architecture arch of data_mem is
    type mem is array(0 to (2 ** addr_width - 1)) of std_logic_vector((data_width - 1) downto 0);
    signal data : mem := (
        others => (others => '0')
    );

    signal read_out: std_logic_vector((data_width - 1) downto 0) := (others => '0');
    signal zero_signal: std_logic_vector((data_width - 1) downto 0) := (others => '0');
begin

    read_process : process( re,clk )
    begin

        if rising_edge(clk) then
            if re = '1' then
                read_out <=  data(to_integer(unsigned(addr)));
            else
                read_out <= zero_signal;
            end if;
        end if;
        
    end process ; -- read_process

    
    dout <=read_out;

    write : process (clk)
    begin
     if rising_edge(clk) then
        if we = '1' then
                data(to_integer(unsigned(addr))) <= din;
          end if;
      end if;
    end process;
end arch;