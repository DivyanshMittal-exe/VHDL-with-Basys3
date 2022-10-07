library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
  port(
    clk : in std_logic;
    inp1 : in std_logic_vector(15 downto 0);
    inp2 : in std_logic_vector(7 downto 0);
    outp : out std_logic_vector(15 downto 0)
  );
end adder;

architecture behavioral of adder is
    outp_signal : std_logic_vector(15 downto 0) := (others => '0');
  begin

    process( clk )
    variable add : signed(15 downto 0) := (others => '0');
    begin
      if rising_edge(clk) then
        add := (signed(inp1)+signed(inp2));
        if(add < 0) then
            add := "11111" & accum(15 downto 5);
        else
            add := "00000" & accum(15 downto 5);
        end if;
        outp_signal <= std_logic_vector(add);
      end if;
    end process ;
    outp <= outp_signal;
end behavioral;