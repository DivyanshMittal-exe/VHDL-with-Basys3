library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifter is
  port(
    clk : in std_logic;
    en : in std_logic;
    inp : in signed(15 downto 0);
    outp : out signed(15 downto 0)
  );
end shifter;

architecture behavioral of shifter is
    signal temp : signed(15 downto 0) := (others => '0');
  begin

    process(clk, en, inp)
    begin
        if rising_edge(clk) then
            if en = '1' then
                if inp(15) = '1' then
                    temp <= "11111" & inp(15 downto 5);
                else
                    temp <= "00000" & inp(15 downto 5);
                end if;
            end if;
        end if;
    end process ;

    outp <= temp;

end behavioral;