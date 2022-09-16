
---- This is just a template file for FSM for now. Will implement in assignment part 2. If this submission is for assignment part 2, I have implemented it, just forgot to remove this comment

--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;


--entity FSM is
--    port (
--        reset          : in std_logic := '0';
--        clk          : in std_logic;
        
--    );
--end FSM;

--architecture behaviour of FSM is
--    type state_enum is (start);
--    signal current_state : state_enum;
--    signal next_state    : state_enum := start;
--begin
--    process (clk, next_state)
--    begin
--        if (rising_edge(clk)) then
--            current_state <= next_state;
--        end if;
--    end process;

--    process (current_state, reset)
--    begin
--        if (reset = '1') then
--            next_state <= start;
--        else
--            case current_state is
--                when start =>               
--                    next_state   <= ;

--                when others =>
--                    next_state <= start;
--            end case;
--        end if;
--    end process;
--end behaviour;
