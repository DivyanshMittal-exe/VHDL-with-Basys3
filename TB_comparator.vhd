library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB is
end TB;

architecture behavior of TB is

    component relu 
        generic(
          inp_width : integer := 16
        );
        port(
          inp : in std_logic_vector((inp_width-1) downto 0);
          outp : out std_logic_vector((inp_width-1) downto 0)
        );
      end component;



    -- signal addr : std_logic_vector(15 downto 0);
    signal din    : std_logic_vector(15 downto 0) := x"0000";
    signal dout    : std_logic_vector(15 downto 0);
begin
    uut : relu 
    generic map(
        inp_width => 16
    )
    port map(

        din,dout
    );

    -- reset <= '0' after 2 ns;

    testing : process
    begin
        
        din <= std_logic_vector( to_signed( -69, 16));


        wait for 10 ns;

        din <= std_logic_vector( to_signed( 69, 16));

        wait for 10 ns;

        din <= std_logic_vector( to_signed( -69, 16));

        wait for 10 ns;

        wait;

    end process ; -- testing

end;