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
        signal dout : std_logic_vector(15 downto 0) := (othesr => '0');

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
        clk <= '0';
        wait for 1 ns;
        identifier : for i in 0 to 190 loop
           din1 <= std_logic_vector(signed(din1)+1,8);
           din2 <= std_logic_vector(signed(din2)+2,16);
           clk <= '1';
           wait for 5 ns;
           clk <= '0';
           if(i mod 10 = 0) then 
               cntrl <= not cntrl;
           end if;
        end loop;
        wait;
    end process clock;
end;