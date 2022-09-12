library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg is
    generic(
        data_width : integer : = 16
    );
    port (
        clk   : in std_logic;
        we    : in std_logic;
        din : in std_logic_vector((data_width-1) downto 0) ;
        dout : in std_logic_vector((data_width-1) downto 0) 
    );

end Reg;

architecture reg_arch of Reg is
    signal store : std_logic_vector(7 downto 0):= "0000000" ;
begin
    dout <= store;
    process (clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                store <= din;
            end if;
        end if;
    end process; -- 

end reg_arch; -- reg_arch