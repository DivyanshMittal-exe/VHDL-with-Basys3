library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
  port (
    A : in integer;
    B : in integer;
    C : in integer;
    D : in integer;
    S : in std_logic_vector(1 downto 0);
    O : out std_logic_vector(3 downto 0)
  );
end mux;

architecture Behavioral of mux is
  signal O_int : integer:= 0;
begin

  O_int <= A when S = "00" else
                B when S = "01" else
                C when S = "10" else
                D;
  O <= std_logic_vector(to_unsigned(O_int,4));

end Behavioral;