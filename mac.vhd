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
   signal accum_signal : signed(15  downto 0) := (others => '0');
begin
  process(clk, cntrl, din1, din2)
    variable accum : signed(23  downto 0) := (others => '0');
    variable mult : signed(23 downto 0) := (others => '0');
    begin
      if rising_edge(clk) then
        mult := signed(din1)*signed(din2);
        report("Accum is " & integer'image(to_integer(accum)) & " " &  integer'image(to_integer(signed(din1)))& " " &  integer'image(to_integer(signed(din2))) );
        if(cntrl = '1') then
          accum := "000000000000000000000000";
        else
          accum := accum + mult ;
          if accum < 0 then 
            accum := "111111111" & accum(14 downto 0);
           else
             accum := "000000000" & accum(14 downto 0);  
           end if;
        end if;
        accum_signal <= accum(15 downto 0);
      end if;
    end process;
  dout <= std_logic_vector(accum_signal);
end;