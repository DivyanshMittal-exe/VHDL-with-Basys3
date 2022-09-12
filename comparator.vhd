library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity relu is
  generic(
    inp_width : integer := 8;
  );
  port(
    inp : in std_logic_vector((inp_width-1) downto 0);
    outp : out std_logic_vector((inp_width-1) downto 0)
  );
end relu;

architecture behavioral of relu is

    comparator : process( inp )
    begin
        if inp >= 0 then
            outp <= inp;
        else
            outp <= std_logic_vector(to_unsigned(0, inp_width));
        end if;
    end process ; -- comparator


end behavioral;