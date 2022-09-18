library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_Rom is
end TB_Rom;

architecture behavior of TB_Rom is

    component rom_mem
         generic(
            addr_width : integer := 16;
            data_width : integer := 16;
            -- 1024(784 used only) + 50816 + 74 is the size
            image_size : integer := 51914;
            image_file_name : string := "imgdata.mif"
      );
      port(
        addr : in std_logic_vector((addr_width-1) downto 0);
        clk : in std_logic;
        re : in std_logic;
        dout : out std_logic_vector((data_width-1) downto 0)
      );
    end component;
    signal clk : std_logic := '0';
    signal re : std_logic := '0';

    signal addr : std_logic_vector(15 downto 0) := x"0000";
    signal dout    : std_logic_vector(7 downto 0) := x"00";
begin
    uut : rom_mem 
    generic map(
        addr_width =>  16,
        data_width => 8,
        -- 1024(784 used only) + 50816 + 74 is the size
        image_size => 784 ,
        image_file_name => "imgdata_digit7.mif"
    )
    port map(

        addr,clk,re,dout
    );

    -- reset <= '0' after 2 ns;

    testing : process
    begin
        
        addr <= x"00CA";
        re <= '1';

        wait for 10 ns;

        addr <= x"00CA";
        re <= '0';

        wait for 10 ns;

        addr <= x"00CB";
        re <= '1';


        wait for 10 ns;

        addr <= x"00CC";
        re <= '1';


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