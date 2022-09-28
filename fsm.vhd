library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity FSM is
    port (
        reset          : in std_logic := '0';
        clk            : in std_logic;
        img_rom_addr   : out integer := 0;
        img_ram_addr   : out integer := 0;
        wt_rom_addr    : out integer := 0;
        img_rom_re     : out std_logic;
        img_ram_we     : out std_logic;
        img_ram_re     : out std_logic;
        wt_rom_re      : out std_logic;
        mac_controler  : out std_logic;
        layer_ram_addr : out integer;
        layer_ram_we   : out std_logic;
        layer_ram_re   : out std_logic;

        mac_mux        : out std_logic;

        do_i_relu      : out std_logic;
        ten_to_one_index  : out integer
    );
end FSM;

architecture behaviour of FSM is
    type state_enum is (start, load_img_in_ram, layer_1_bookkeep, multiply_l1, layer_2_bookkeep, multiply_l2, get_max_of_ten,get_out);
    signal current_state  : state_enum;
    signal next_state     : state_enum := start;
    -- signal mover := integer
    signal ram_pull_index : integer    := 0;
    signal l1_index_i     : integer    := 0;
    signal l1_index_j     : integer    := 0;
    signal l2_index_i     : integer    := 0;
    signal l2_index_j     : integer    := 0;
    signal fsm_mover      : std_logic  := '1';

    signal ten_max_index  : integer    := 0;

begin
    process (clk, next_state)
    begin
        if (rising_edge(clk)) then
            if current_state = next_state then
                fsm_mover <= not fsm_mover;
            else
                current_state <= next_state;
            end if;
        end if;
    end process;

    -- Dependance on ram_pull_index is important
    process (current_state, reset, fsm_mover)
    begin
        if (reset = '1') then
            next_state <= start;
        else
            case current_state is
                when start =>
                    next_state <= load_img_in_ram;
                    -- addr
                when load_img_in_ram =>
                    if ram_pull_index >= 784 then
                        next_state <= layer_1_bookkeep;
                        l1_index_j <= 0;
                    else
                        next_state     <= load_img_in_ram;
                        ram_pull_index <= ram_pull_index + 1;
                    end if;

                    img_ram_addr <= ram_pull_index; -- - 1;
                    img_rom_addr <= ram_pull_index; -- - 1;
                    img_rom_re   <= '1';
                    img_ram_we   <= '1';

                when layer_1_bookkeep =>

                    if l1_index_j >= 64 then
                        next_state <= layer_2_bookkeep;
                        l2_index_i <= 0;
                        l2_index_j <= 0;
                    else
                        l1_index_j <= l1_index_j + 1;
                        next_state <= multiply_l1;
                    end if;

                    l1_index_i    <= 0;
                    mac_controler <= '1';

                when multiply_l1 =>
                    if l1_index_i >= 784 then
                        next_state     <= layer_1_bookkeep;
                        layer_ram_addr <= l1_index_j;
                        layer_ram_we   <= '1';
                        do_i_relu      <= '1';
                    else
                        next_state <= multiply_l1;
                        l1_index_i <= l1_index_i + 1;
                    end if;
                    img_ram_addr <= l1_index_i;                    -- - 1;
                    wt_rom_addr  <= l1_index_j * 784 + l1_index_i; -- - 1;

                    img_ram_re   <= '1';
                    wt_rom_re    <= '1';
                    mac_mux      <= '0';

                when layer_2_bookkeep =>
                    if l2_index_j >= 10 then
                        next_state    <= get_max_of_ten;
                        ten_max_index <= 0;
                    else
                        l2_index_j <= l2_index_j + 1;
                        next_state <= multiply_l2;
                    end if;

                    l2_index_i    <= 0;
                    mac_controler <= '1';

                when multiply_l2 =>
                    if l2_index_i >= 64 then
                        next_state     <= layer_2_bookkeep;
                        layer_ram_addr <= l2_index_j + 64;
                        layer_ram_we   <= '1';
                        do_i_relu      <= '0';
                    else
                        next_state <= multiply_l2;
                        l2_index_i <= l2_index_i + 1;
                    end if;

                    layer_ram_addr <= l2_index_i;                           -- - 1;
                    wt_rom_addr    <= 50240 + l2_index_j * 64 + l2_index_i; -- - 1;

                    layer_ram_re   <= '1';
                    wt_rom_re      <= '1';
                    mac_mux        <= '1';

                when get_max_of_ten =>
                    if ten_max_index >= 10 then
                        next_state <= get_out;
                    else
                        ten_max_index <= ten_max_index + 1;
                    end if;

                    ten_to_one_index <= ten_max_index;      -- - 1;  
                    layer_ram_addr   <= ten_max_index + 64; --  + 63;
                    layer_ram_re     <= '1';
                when get_out =>
                    next_state <= get_out;

                when others =>
                    next_state <= start;
            end case;
        end if;
    end process;
end behaviour;
