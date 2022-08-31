library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
  port (
    A : in std_logic_vector(3 downto 0);
    B : in std_logic_vector(3 downto 0);
    C : in std_logic_vector(3 downto 0);
    D : in std_logic_vector(3 downto 0);
    S : in std_logic_vector(1 downto 0);
    O : out std_logic_vector(3 downto 0)
  );
end mux;

architecture Behavioral of mux is
  signal rev : std_logic_vector(3 downto 0);
begin

  rev <= A when S = "00" else
    B when S = "01" else
    C when S = "10" else
    D;

  O(3) <= rev(0);
  O(2) <= rev(1);
  O(1) <= rev(2);
  O(0) <= rev(3);
end Behavioral;