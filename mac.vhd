library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mac is
  Port ( 
    din1 : in signed(7 downto 0);
    din2 : in signed(15 downto 0);
    clk : in std_logic;
    cntrl : in std_logic;
    dout : out signed(15 downto 0)
  );
end mac;

architecture behavioral of mac is
  signal accum : signed(15 downto 0) := (others => '0');
  signal mult : signed(23 downto 0) := (others => '0');
begin
  process(clk, cntrl, din1, din2)
    begin
      if rising_edge(clk) then
        mult <= din1*din2;
        if(cntrl = '1') then
          accum <= mult(15 downto 0);
        else
          accum <= accum+mult(15 downto 0);
        end if;
      end if;
    end process;
  dout <= accum;
end;