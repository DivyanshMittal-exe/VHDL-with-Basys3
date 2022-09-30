library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity seven_seg_decoder is
  Port ( 
    sw1: in STD_LOGIC_VECTOR(3 downto 0);
    seg1: out STD_LOGIC_VECTOR(6 downto 0)
    
  );
end seven_seg_decoder;

architecture Behavioral of seven_seg_decoder is
begin


    seg1(6) <=  ((not sw1(3)) and (not sw1(2)) and (not sw1(1)) and sw1(0)) or (sw1(2) and (not sw1(1)) and (not sw1(0)));
    seg1(5) <=  ( sw1(2) and (not sw1(1)) and sw1(0)) or (sw1(2) and sw1(1) and (not sw1(0)));
    seg1(4) <=  ( (not sw1(3)) and (not sw1(2)) and sw1(1) and (not sw1(0)));
    seg1(3) <=  ( (not sw1(3)) and (not sw1(2)) and (not sw1(1)) and sw1(0)) or ( sw1(2) and sw1(1) and sw1(0)) or (sw1(2) and (not sw1(1)) and (not sw1(0)));
    seg1(2) <=  ( sw1(2) and (not sw1(1))) or sw1(0);
    seg1(1) <=  (sw1(1) and (not sw1(2))) or (sw1(1) and sw1(0)) or ((not sw1(3)) and (not sw1(2)) and (sw1(0)));
    seg1(0) <=  ((not sw1(3)) and (not sw1(2)) and (not sw1(1))) or ( sw1(2) and sw1(1) and sw1(0)) ;
end Behavioral;