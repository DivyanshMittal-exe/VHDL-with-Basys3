library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_seg is
    port(
        sw : in std_logic_vector(3 downto 0);
        -- number : in integer; -- for the lighting of the 4 lights (0 to 3)
        seg : out std_logic_vector(6 downto 0)
        -- an : out std_logic_vector(3 downto 0);
    );
end seven_seg;

architecture beh of seven_seg is
begin
    -- lighting of the according to the number input
    -- process(number) is
    --     begin
    --         case number is
    --             when 0 => an <= "0111";
    --             when 1 => an <= "1011";
    --             when 2 => an <= "1101";
    --             when 3 => an <= "1110";
    --             when others => an <= "1111";
    --         end case;
    -- end process;
    -- segment 6 refers to the topmost segment, while segment 0 refers to the middle segment
    seg(6) <= ((not sw(0)) and (not sw(1)) and (not sw(2)) and sw(3)) or (sw(1) and (not sw(2)) and (not sw(3)));
    seg(5) <= (sw(1) and (not sw(2)) and sw(3)) or (sw(1) and sw(2) and (not sw(3)));
    seg(4) <= (not sw(0)) and (not sw(1)) and sw(2) and (not sw(3));
    seg(3) <= (sw(1) and (not sw(2)) and (not sw(3))) or ((not sw(0)) and (not sw(1)) and (not sw(2)) and sw(3)) or (sw(1) and sw(2) and sw(3));
    seg(2) <= (sw(1) and (not sw(2))) or sw(3);
    seg(1) <= ((not sw(1)) and sw(2)) or (sw(2) and sw(3)) or ((not sw(0)) and (not sw(1)) and sw(3));
    seg(0) <= ((not sw(0)) and (not sw(1)) and (not sw(2))) or (sw(1) and sw(2) and sw(3));
end beh;