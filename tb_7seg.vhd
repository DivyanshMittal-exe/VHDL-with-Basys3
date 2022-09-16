library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_7seg is
end TB_7seg;

architecture beh of TB_7seg is
    component seven_seg_decoder
        port ( 
            sw1: in STD_LOGIC_VECTOR(3 downto 0);
            seg1: out STD_LOGIC_VECTOR(6 downto 0)
            
        );
        end component;

        signal sw : STD_LOGIC_VECTOR(3 downto 0) := "0000";
        signal seg1 : STD_LOGIC_VECTOR(6 downto 0) := "0000000";


begin
    uut : seven_seg_decoder
    port map(
        sw,seg1
    );

    clock : process
    begin
        for i in 0 to 10 loop
            sw <= std_logic_vector(unsigned(sw) + 1);
            wait for 2 ns;
        end loop;
        wait;
    end process clock;
end;
