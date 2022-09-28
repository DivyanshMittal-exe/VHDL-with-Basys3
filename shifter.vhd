library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifter is
  port(
    inp : in std_logic_vector(15 downto 0);
    outp : out std_logic_vector(15 downto 0)
  );
end shifter;

architecture behavioral of shifter is
    signal temp : std_logic_vector(15 downto 0) := (others => '0');
  begin


    outp <="00000" & inp(15 downto 5) when inp(15) = '0' else "11111" & inp(15 downto 5);

end behavioral;