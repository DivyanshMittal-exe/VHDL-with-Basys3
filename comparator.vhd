library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity relu is
  generic(
    inp_width : integer := 16
  );
  port(
    inp : in std_logic_vector((inp_width-1) downto 0);
    outp : out std_logic_vector((inp_width-1) downto 0)
  );
end relu;

architecture behavioral of relu is
  begin

    comparator_process : process( inp )
    begin
        if signed(inp) > 0 then
            outp <= inp;
        else
            outp <= (others => '0');
        end if;
    end process ;


end behavioral;