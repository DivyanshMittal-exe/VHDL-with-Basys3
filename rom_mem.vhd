
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity rom_mem is
    generic (
    ADDR_WIDTH : integer := 10;
    DATA_WIDTH : integer := 8;
    IMAGE_SIZE : integer := 784;
    IMAGE_FILE_NAME : string :="file.mif"
    );
  port (
    addr : in std_logic_vector((ADDR_WIDTH - 1) downto 0);
    clk  : in std_logic;
    re   : in std_logic;
    dout : out std_logic_vector((DATA_WIDTH - 1) downto 0)
  );
end rom_mem;

architecture behavioral of rom_mem is
  signal zero_signal : std_logic_vector((data_width - 1) downto 0) := (others => '0');

  TYPE mem_type IS ARRAY(0 TO IMAGE_SIZE-1) OF std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
    impure function init_mem(mif_file_name : in string) return mem_type is
        file mif_file : text open read_mode is mif_file_name;
        variable mif_line : line;
        variable temp_bv : bit_vector(DATA_WIDTH-1 downto 0);
        variable temp_mem : mem_type;
        begin
        for i in mem_type'range loop
         if(not endfile(mif_file)) then
            readline(mif_file, mif_line);
            read(mif_line, temp_bv);
            temp_mem(i) := to_stdlogicvector(temp_bv);
           else 
            exit;
            end if;
        end loop;
        return temp_mem;
    end function;   

  signal rom_block   : mem_type := init_mem(IMAGE_FILE_NAME);
  signal out_sig     : std_logic_vector(data_width - 1 downto 0) := (others => '0');

begin
  process (clk, addr, re)
  begin
    if (rising_edge(clk)) then
      if (re = '1') then
        out_sig <= rom_block(to_integer(unsigned(addr)));
      else
        out_sig <= zero_signal;
      end if;
    end if;
  end process;

  dout <= out_sig;

end behavioral;