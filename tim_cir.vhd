library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tim is
  port (
    clk : in std_logic;
    AN  : out std_logic_vector(3 downto 0);
    S   : out std_logic_vector(1 downto 0);
    dp  : out std_logic

  );
end tim;

architecture Behavioral of tim is

  component modulo is
    generic (
      modulo_n : integer := 2e5
    );
    port (
      clk   : in std_logic;
      clr   : in std_logic;
      pause : in std_logic;
      O     : out integer;
      bit_O : out std_logic
    );
  end component;

  signal tally       : std_logic_vector(1 downto 0) := "00";
  signal modulo_2e5_out : integer                      := 0;
  signal bit_tally   : std_logic                    := '0';
begin

  modulo_2e5_clock_slower : modulo
  generic map(
    modulo_n => 2e5
  )
  port map(
    clk   => clk,
    clr   => '0',
    pause => '0',
    O     => modulo_2e5_out,
    bit_O => bit_tally
  );

  
  process (bit_tally)
  begin
    if rising_edge (bit_tally) then
      if tally = "11" then
        tally <= "00";
      else
        tally <= std_logic_vector(unsigned(tally) + 1);
      end if;
    end if;
  end process;

  S  <= tally;

  AN <= "1110" when tally = "00" else
    "1101" when tally = "01" else
    "1011" when tally = "10" else
    "0111";

  dp <= '1' when tally = "00" or tally = "10" else
    '0';
end Behavioral;