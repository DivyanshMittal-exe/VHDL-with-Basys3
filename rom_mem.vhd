library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity rom_mem is
  generic(
    addr_width : integer := 17;
    data_width : integer := 8;
    -- 784 + 1017770 is the size
    image_size : integer := 102554;
    image_file_name : string := "imgdata.mif"
  );
  port(
    addr : in std_logic_vector((addr_width-1) downto 0);
    clk : in std_logic;
    re : in std_logic;
    dout : out std_logic_vector((data_width-1) downto 0)
  );
end mac;

architecture behavioral of rom_mem is
  type mem_type is array(0 to (image_size-1)) of std_logic_vector((data_width-1) downto 0);

  impure function init_mem(mif_file_name : in string) return mem_type is
    file mif_file : text open read_mode is mif_file_name;
    variable mif_line : line;
    variable temp_bv : bit_vector((data_width-1) downto 0);
    variable temp_mem : mem_type;
  begin
    for i in mem_type'range loop
      readline(mif_file, mif_line);
      read(mif_line, temp_bv);
      temp_mem(i) := to_stdlogicvector(temp_bv);
    end loop;
    return temp_mem;
  end function;

  signal rom_block : mem_type := init_mem(image_file_name);
begin
  process(clk, addr, re)
  begin
    if(rising_edge(clk)) then
      if(re = '1') then
        dout <= rom_block(unsigned(addr));
      else
        dout <= "00000000";
      end if;
    end if;
  end process;

end behavioral;