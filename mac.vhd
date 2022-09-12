library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mac is
  Port ( 
    din1 : in std_logic_vector(7 downto 0);
    din2 : in std_logic_vector(15 downto 0);
    clk : in std_logic;
    cntrl : in std_logic;
    dout : out std_logic_vector(15 downto 0)
  );
end mac;

architecture behavioral of mac is
  signal accum : std_logic_vector(7 downto 0) := (others => '0');
  signal mult : std_logic_vector(23 downto 0) := (others => '0');
begin
  process(clk, cntrl, din1, din2)
    begin
      if rising_edge(clk) then
        mult <= std_logic_vector(signed(din1)*signed(din2),24);
        if(cntrl = '1') then
          accum <= mult
        else
          accum <= std_logic_vector(signed(accum)+signed(mult),24)(15 downto 0);
        end if;
      end if;
    end process;
  dout <= accum;
end mac;
