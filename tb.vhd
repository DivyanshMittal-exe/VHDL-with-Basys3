library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_main is
end TB_main;

architecture behavior of TB_main is


    component glue is
        port (
            clk : in std_logic;
            seg : out std_logic_vector(6 downto 0);
            an  : out std_logic_vector(3 downto 0)
        );
    end component;
    signal clk : std_logic := '0';
    signal seg: std_logic_vector(6 downto 0) ;
    signal an: std_logic_vector(3 downto 0) ;
    
begin
    uut : glue 

    port map(
        clk => clk,
        seg => seg,
        an => an
    );

    -- reset <= '0' after 2 ns;

    clk_gen : process
    begin

        clk <= '0';
        wait for 1 ps;

        identifier : for i in 0 to 10846 loop
            clk <= '1';
            wait for 10 ps;
            clk <= '0';
            wait for 10 ps;
        end loop; -- identifier loop
        wait;
    end process clk_gen;
end;