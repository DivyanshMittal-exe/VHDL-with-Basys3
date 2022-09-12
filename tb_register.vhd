library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture beh of tb is
    component reg
        port(
            clk   : in std_logic;
            we    : in std_logic;
            din : in std_logic_vector(15 downto 0) ;
            dout : in std_logic_vector(15 downto 0)
        );
        end component;
        signal clk : std_logic := '0';
        signal we : std_logic := '0';
        signal din : std_logic_vector(15 downto 0) := (others => '0');
        signal dout : std_logic_vector(15 downto 0) := (others => '0');

begin
    uut : reg port map(
        clk => clk,
        we => we,
        din => din,
        dout => dout
    );

    clock : process
    begin
        clk <= '0';
        wait for 1 ns;
        identifier : for i in 0 to 190 loop
            din <= std_logic_vector(signed(din1)+1,16);
            we <= not we;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
        end loop;
        wait;
    end process clock;
end;
