library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture beh of tb is

    component mac
        port(
            din1 : in std_logic_vector(7 downto 0);
            din2 : in std_logic_vector(15 downto 0);
            clk : in std_logic;
            cntrl : in std_logic;
            dout : out std_logic_vector(15 downto 0)
        );
        end component;
        signal clk : std_logic := '0';
        signal din1 : std_logic_vector(7 downto 0) := (others => '0')
        signal din2 : std_logic_vector(15 downto 0) := (others => '0')
        signal cntrl : std_logic : = '0';


begin
    uut : processor port map(
        din1 => din1,
        din2 => din2,
        clk => clk,
        cntrl => cntrl,
        dout => dout
    );
    

end;