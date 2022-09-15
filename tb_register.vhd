library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture beh of tb is
    component reg
        generic(
            data_width : integer := 16
        );
        port(
            clk   : in std_logic;
            we    : in std_logic;
            din : in std_logic_vector((data_width-1) downto 0);
            dout : out std_logic_vector((data_width-1) downto 0)
        );
        end component;
        signal clk : std_logic := '0';
        signal we : std_logic := '0';
        signal din : std_logic_vector(15 downto 0) := (others => '0');
        signal dout : std_logic_vector(15 downto 0) := (others => '0');

begin
    uut : reg
    generic map(
        data_width => 16
    )
    port map(
        clk => clk,
        we => we,
        din => din,
        dout => dout
    );

    clock : process
    begin
        for i in 0 to 10 loop
            wait for 2 ns;
            din <= std_logic_vector(signed(din)+1);
            we <= not we;
            clk <= '1';
            wait for 2 ns;
            clk <= '0';
        end loop;
        wait;
    end process clock;
end;
