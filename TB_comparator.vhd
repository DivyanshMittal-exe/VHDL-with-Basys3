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
          inp : in signed((inp_width-1) downto 0);
          outp : out signed((inp_width-1) downto 0)
        );
      end component;



    -- signal addr : std_logic_vector(15 downto 0);
    signal din    : signed(15 downto 0) := (others=>'0');
    signal dout    : signed(15 downto 0);
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
        
        din <= to_signed( -69, 16);


        wait for 10 ns;

        din <= to_signed( 69, 16);

        wait for 10 ns;

        din <= to_signed( -69, 16);

        wait for 10 ns;

        wait;

    end process ; -- testing

end;