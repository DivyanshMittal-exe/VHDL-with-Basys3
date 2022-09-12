library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB is
end TB;

architecture behavior of TB is

    component data_mem
        generic (
            addr_width : integer := 16;
            data_width : integer := 16

        );
        port (
            clk : in std_logic;
            we    : in std_logic;

            addr : in std_logic_vector(15 downto 0);
            din    : in std_logic_vector(15 downto 0);
            dout    : out std_logic_vector(15 downto 0)

        );
    end component;
    signal clk : std_logic := '0';
    signal we : std_logic := '0';

    signal addr : std_logic_vector(15 downto 0) := x"0000";
    signal din    : std_logic_vector(15 downto 0) := x"0000";
    signal dout    : std_logic_vector(15 downto 0) := x"0000";
begin
    uut : data_mem 
    generic map(
        addr_width => 16,
        data_width => 16
    )
    port map(

        clk,we,addr,din,dout
    );

    -- reset <= '0' after 2 ns;

    testing : process
    begin
        
        addr <= x"0001";
        din <= x"0069";
        we <= '1';

        wait for 10 ns;

        addr <= x"0002";
        din <= x"0069";
        we <= '0';

        wait for 10 ns;

        addr <= x"0002";
        din <= x"0069";
        we <= '1';

        wait for 10 ns;
        wait;


    end process ; -- testing

    clk_gen : process
    begin

        clk <= '0';
        wait for 1 ns;

        identifier : for i in 0 to 190 loop
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
        end loop; -- identifier loop
        wait;
    end process clk_gen;
end;