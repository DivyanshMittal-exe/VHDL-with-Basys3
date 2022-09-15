library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture beh of tb is

    component mac
        port(
            din1 : in signed(7 downto 0);
            din2 : in signed(15 downto 0);
            clk : in std_logic;
            cntrl : in std_logic;
            dout : out signed(15 downto 0)
        );
        end component;

        signal clk : std_logic := '0';
        signal din1 : signed(7 downto 0) := (others => '0');
        signal din2 : signed(15 downto 0) := (others => '0');
        signal cntrl : std_logic := '0';
        signal dout : signed(15 downto 0) := (others => '0');

begin
    uut : mac port map(
        din1 => din1,
        din2 => din2,
        clk => clk,
        cntrl => cntrl,
        dout => dout
    );
    
    clock : process
    begin
        for i in 0 to 10 loop
            wait for 2 ns;
            din1 <= din1 + 1;
            din2 <= din2 + 1;
            clk <= '1';
            wait for 2 ns;
            clk <= '0';
        end loop;
        wait;
    end process clock;
end;