
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity TB is
end TB;

architecture behavior of TB is

    component processor
        port (
            clk : in std_logic;
            we    : in std_logic;

            addr : in std_logic_vector(7 downto 0);
            din    : in std_logic_vector(7 downto 0);
            dout    : out std_logic_vector(7 downto 0)

        );
    end component;
    signal clk : std_logic := '0';
    signal rweeset : std_logic := '0';
begin
    uut : processor port map(

        reset => reset,
        clock => clock
    );

    reset <= '0' after 2 ns;

    Clock_gen : process
    begin

        clock <= '0';
        wait for 1 ns;

        identifier : for i in 0 to 190 loop
            clock <= '1';
            wait for 5 ns;
            clock <= '0';
            wait for 5 ns;
        end loop; -- identifier loop
        wait;
    end process Clock_gen;
end;