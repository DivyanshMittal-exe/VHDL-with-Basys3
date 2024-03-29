library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity FSM is
    port (
        clk              : in std_logic;
        rom_addr     : out integer;
        ram_addr     : buffer integer;
        rom_re       : out std_logic;
        ram_we       : out std_logic;
        ram_re       : out std_logic;
        mac_controler    : out std_logic;
        ram_mux          : out std_logic_vector(1 downto 0);
        ten_to_one_index : out integer
    );
end FSM;

architecture behaviour of FSM is
    type state_enum is (start, load_img_in_ram, layer_1_bookkeep, multiply_l1, layer_2_bookkeep, multiply_l2, get_max_of_ten, get_out, relu, adder1, adder2);
    signal current_state  : state_enum;
    signal next_state     : state_enum := start;
    -- signal mover := integer
    signal ram_pull_index : integer    := 0;
    signal ram_pull_index_next : integer := 0;
    signal l1_index_i     : integer    := 0;
    signal l1_index_j     : integer    := 0;
    signal l2_index_i     : integer    := 0;
    signal l2_index_j     : integer    := 0;
    signal l1_index_i_next : integer := 0;
    signal l1_index_j_next : integer := 0;
    signal l2_index_i_next : integer := 0;
    signal l2_index_j_next : integer := 0;
    signal ram_addr_prev : integer := 0;
    
    signal ten_max_index_local  : integer    := 11;
    signal ten_max_index_local_next : integer := 11;
--    signal ten_max_index : integer := 11;

begin
    process (clk, next_state, l1_index_i_next, l1_index_j_next,l2_index_i_next,l2_index_j_next, ram_pull_index_next, ten_max_index_local_next, ram_addr)
    begin
        if (rising_edge(clk)) then
             
             current_state <= next_state;
             l1_index_i <= l1_index_i_next;
             l1_index_j <= l1_index_j_next;
             l2_index_i <= l2_index_i_next;
             l2_index_j <= l2_index_j_next;
             ram_pull_index <= ram_pull_index_next;
             ten_max_index_local <= ten_max_index_local_next;
             ram_addr_prev <= ram_addr;
             
--            if current_state = next_state then
--                fsm_mover <= not fsm_mover;
--            else
--                current_state <= next_state;
--            end if;
        end if;
    end process;

    -- Dependance on ram_pull_index is important
    process (current_state, l1_index_i, l1_index_j, l2_index_i, l2_index_j, ram_pull_index, ten_max_index_local, ram_addr_prev)
    begin
        rom_re    <= '0';
        ram_we    <= '0';
        ram_re    <= '1';
        mac_controler <= '0';
        ram_mux       <= "01";
        l1_index_i_next <= l1_index_i;
        l1_index_j_next <= l1_index_j;
        l2_index_i_next <= l2_index_i;
        l2_index_j_next <= l2_index_j;
        ram_pull_index_next <= ram_pull_index;
        ten_max_index_local_next <= ten_max_index_local;
        next_state <= current_state;
        rom_addr <= 0;
        ram_addr <= ram_addr_prev;
--        ram_addr <= ram_pull_index;
        ten_to_one_index <= ten_max_index_local-1;
--        ten_max_index <= 11;

            case current_state is
                when start =>
                    report("Starting");
                    next_state <= load_img_in_ram;
                    -- addr
                when load_img_in_ram =>
                       report "The value of 'a' is " & integer'image(ram_pull_index);

                    if ram_pull_index >= 784 then
                        report("Starting image load");

                        next_state <= layer_1_bookkeep;
                        l1_index_j_next <= 0;
                        l1_index_i_next <= 0;

                    else
                        next_state     <= load_img_in_ram;
                        ram_pull_index_next <= ram_pull_index + 1;
                    end if;

                    ram_addr <= ram_pull_index - 1; -- - 1;
                    rom_addr <= ram_pull_index; -- - 1;
                    rom_re   <= '1';
                    ram_we   <= '1';

                    ram_mux       <= "00";

                when layer_1_bookkeep =>
                    report("Bookkeeping l1 " & integer'image(l1_index_j) & " " &integer'image(l1_index_i) );

                    if l1_index_j > 64 then
                        next_state <= layer_2_bookkeep;
                        l2_index_i_next <= 0;
                        l2_index_j_next <= 0;
                    elsif l1_index_j = 64 then
                        next_state <= multiply_l1;
--                        l2_index_i_next <= 0;
--                        l2_index_j_next <= 0;
                    else
                        
                        next_state <= multiply_l1;
                        

                        
                    end if;
                    ram_we        <= '1';
                    ram_mux       <= "01";
                    l1_index_i_next    <= 0;
                    mac_controler <= '1';

                when multiply_l1 =>
                    report("Multiplying l1 " & integer'image(l1_index_j) & " " &integer'image(l1_index_i)& " "  &integer'image(1024 + l1_index_j * 784 + l1_index_i));
                    if l1_index_i >= 784 then
                        next_state     <= adder1;
                        rom_addr       <= 51200 + l1_index_j;
                        rom_re         <= '1';
                        ram_addr <= l1_index_j + 800;
                        
                        l1_index_j_next <= l1_index_j + 1;
                        
                    else
                        next_state <= multiply_l1;
                        l1_index_i_next <= l1_index_i + 1;
                        if 1024 + l1_index_j*784 + l1_index_i < 51914 then
                            rom_addr  <= 1024 + l1_index_j * 784 + l1_index_i; -- - 1;
                        end if;
                        ram_addr <= l1_index_i;                    -- - 1;

                        ram_re       <= '1';
                        rom_re       <= '1';
                        -- ram_mux      <= '0';
    

                    end if;

                when adder1 =>
--                        next_state <= shifter1;
                        next_state <= relu;
                        ram_we <= '0';
                        ram_re <= '0';
                        rom_re <= '0';
                        
--                when shifter1 => 
--                    next_state <= relu;
--                    ram_we <= '0';
--                    ram_re <= '0';
--                    rom_re <= '0';

                when relu =>
--                    if l1_index_j = 64 then
--                       next_state <= layer_2_bookkeep;
--                       l2_index_i_next <= 0;
--                       l2_index_j_next <= 0;
--                       ram_we        <= '1';
--                       ram_mux       <= "01";
--                       l1_index_i_next    <= 0;
--                       mac_controler <= '1';
                       
--                    else
                        next_state <= layer_1_bookkeep;
                        ram_we <= '0';
                        ram_re <= '0';
                        rom_re <= '0';
--                    end if;

                when layer_2_bookkeep =>
                           report("Bookkeeping l2 " & integer'image(l2_index_j) & " " &integer'image(l2_index_i) );

                    if l2_index_j >= 10 then
                        next_state    <= get_max_of_ten;
                        ten_max_index_local_next <= 0;
                    else
                        next_state <= multiply_l2;
                        
                    end if;
                    ram_we   <= '1';
                    ram_mux       <= "10";
                    l2_index_i_next    <= 0;
                    mac_controler <= '1';

                when multiply_l2 =>
                      report("Multiplying l2 " & integer'image(l2_index_j) & " " &integer'image(l2_index_i) );

                    if l2_index_i >= 64 then
                        next_state     <= adder2;
                        rom_addr       <= 51904 + l2_index_j;
                        rom_re         <= '1';
                        ram_addr <= l2_index_j + 864;

                        l2_index_j_next <= l2_index_j + 1;

                    else
                        next_state <= multiply_l2;
                        l2_index_i_next <= l2_index_i + 1;
                        rom_addr    <= 51264 + l2_index_j * 64 + l2_index_i; -- - 1;
                        ram_addr <= l2_index_i + 800;
                    end if;

                                               -- - 1;

                    ram_re   <= '1';
                    rom_re      <= '1';
                    -- ram_mux        <= '1';

                when adder2 =>
--                    next_state <= shifter2;
                    next_state <= layer_2_bookkeep;
                    ram_we <= '0';
                    ram_re <= '0';
                    rom_re <= '0';
               
                    
--                when shifter2 =>
--                    next_state <= layer_2_bookkeep;
--                    ram_we <= '0';
--                    ram_re <= '0';
--                    rom_re <= '0';

                when get_max_of_ten =>
                    if ten_max_index_local >=  10 then
                        next_state <= get_out;
                    else
                        ten_max_index_local_next <= ten_max_index_local + 1;
                    end if;

--                    ten_max_index <= ten_max_index_local-1;      -- - 1;
                      ten_to_one_index <= ten_max_index_local-1;  
                    ram_addr   <= ten_max_index_local + 864; --  + 63;
                    ram_re     <= '1';
                when get_out =>
                    next_state <= get_out;

                when others =>
                    next_state <= start;
            end case;

    end process;
    
--    ten_to_one_index <= ten_max_index;
    
end behaviour;
