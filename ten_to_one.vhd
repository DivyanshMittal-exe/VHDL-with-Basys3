library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ten_to_one is
  port ( 
    clk : in std_logic;
    value: in std_logic_vector(15 downto 0) ;
    index : in integer;
    max_index : out integer
  );
end ten_to_one;

architecture behavioral of ten_to_one is
    signal max_val: std_logic_vector(15 downto 0):= "0000000000000000";
    signal max_index_local: integer:= 10;

begin
  process(clk)
    begin
      if rising_edge(clk) and index < 10 then
         report("Value and index " & integer'image(to_integer(signed(value))) & " " &integer'image(index) );
        if signed(value) > signed(max_val) then
            max_val <= value;
            max_index_local <= index;
        end if;
      end if;
    end process;
    max_index <= max_index_local;
end;