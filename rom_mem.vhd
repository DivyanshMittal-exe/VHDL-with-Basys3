library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity rom_mem is
  generic (
    addr_width      : integer := 16;
    data_width      : integer := 16;
    -- 1024(784 used only) + 50816 + 74 is the size
    image_size      : integer := 51914;
    image_file_name : string  := "imgdata_digit7.mif"
  );
  port (
    addr : in std_logic_vector((addr_width - 1) downto 0);
    clk  : in std_logic;
    re   : in std_logic;
    dout : out std_logic_vector((data_width - 1) downto 0)
  );
end rom_mem;

architecture behavioral of rom_mem is
  type mem_type is array(0 to (image_size - 1)) of std_logic_vector((data_width - 1) downto 0);

  impure function init_mem(mif_file_name : in string) return mem_type is
    file mif_file                          : text open read_mode is image_file_name;
    variable mif_line                      : line;
    variable temp_bv                       : bit_vector((data_width - 1) downto 0);
    variable temp_mem                      : mem_type;
  begin
    for i in mem_type'range loop
      readline(mif_file, mif_line);
      read(mif_line, temp_bv);
      temp_mem(i) := to_stdlogicvector(temp_bv);
    end loop;
    return temp_mem;
  end function;

  signal rom_block   : mem_type                                    := init_mem(image_file_name);
  signal zero_signal : std_logic_vector((data_width - 1) downto 0) := (others => '0');
  signal out_sig     : std_logic_vector((data_width - 1) downto 0) := (others => '0');

begin
  process (clk, addr, re)
  begin
    if (rising_edge(clk)) then
      if (re = '1') then
        dout <= rom_block(to_integer(unsigned(addr)));
      else
        dout <= zero_signal;
      end if;
    end if;
  end process;

--  dout <= out_sig;

end behavioral;