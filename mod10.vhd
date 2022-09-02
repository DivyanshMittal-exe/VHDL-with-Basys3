library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod10 is
  port (
    clk   : in std_logic;
    clr   : in std_logic;
    pause : in std_logic;
    O     : out std_logic_vector(3 downto 0);
    bit_O : out std_logic
  );
end mod10;

architecture Behavioral of mod10 is
  signal tally     : std_logic_vector(3 downto 0) := "0000";
  signal bit_tally : std_logic                    := '0';
begin
  process (clk, pause, clr)
  begin
    if clr = '1' then 
    tally     <= "0000";
    bit_tally <= '0';
  elsif pause = '1' then
    tally     <= tally;
    bit_tally <= '0';
  elsif rising_edge (clk) then
    if tally = "1001" then
      tally     <= "0000";
      bit_tally <= '1';
    else
      tally     <= std_logic_vector(unsigned(tally) + 1);
      bit_tally <= '0';
    end if;
  end if;

end process;


  bit_O <= bit_tally;
  O <= tally;

end Behavioral;