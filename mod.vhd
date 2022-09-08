library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modulo is
generic(modulo_n: integer);
  port (
    clk   : in std_logic;
    clr   : in std_logic;
    pause : in std_logic;
    O: out integer ;
    bit_O : out std_logic
  );
end modulo;

architecture modulo_wrk of modulo is
  signal tally     : integer   := 0;
  signal bit_tally : std_logic := '0';
begin
  process (clk, pause, clr)

  begin

    if clr = '1' then 
      tally     <= 0;
      bit_tally <= '0';
    elsif pause = '1' then
      tally     <= tally;
      bit_tally <= '0';
    elsif rising_edge (clk) then
      if tally = modulo_n-1 then
        tally     <= 0;
        bit_tally <= '1';
      else
        tally     <= tally + 1;
        bit_tally <= '0';
      end if;
    end if;

  end process;
  O <= tally;
  bit_O <= bit_tally;

end modulo_wrk;