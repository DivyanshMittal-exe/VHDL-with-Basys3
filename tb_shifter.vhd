library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_Shift is
end TB_Shift;

architecture beh of TB_Shift is
    component shifter
        port(
            clk   : in std_logic;
            en    : in std_logic;
            inp : in signed(15 downto 0);
            outp : out signed(15 downto 0)
        );
        end component;

        signal clk : std_logic := '0';
        signal en : std_logic := '0';
        signal inp : signed(15 downto 0) := "0000000000000001";
        signal outp : signed(15 downto 0) := (others => '0');

begin
    uut : shifter
    port map(
        clk => clk,
        en => en,
        inp => inp,
        outp => outp
    );

    clock : process
    begin
        for i in 0 to 10 loop
            wait for 2 ns;
            inp <= inp+inp+inp;
            en <= not en;
            clk <= '1';
            wait for 2 ns;
            clk <= '0';
        end loop;
        wait;
    end process clock;
end;
