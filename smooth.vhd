library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity smooth is
   Port (
     clk : in std_logic;
     btn_in : in std_logic;
     btn_out : out std_logic
   );
end smooth;

architecture Behavioral of smooth  is
signal counter : integer := 0;
begin
	process(clk, btn_in)
	begin
        
        if rising_edge(clk) then 
            if btn_in = '1' then
                if counter = 1e6 then
                    counter <= 1e6;
                else
                    counter <= counter + 1;
                end if;
            elsif(btn_in = '0') then
                counter <= 0;
            end if;
        end if;
        
		
	end process;

	btn_out <= '1' when counter = 1e6 else
		   '0';
end Behavioral;
