library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity glue is
    port (
        clk  : in std_logic;
        btnL : in std_logic;
        btnC : in std_logic;
        btnR : in std_logic;
        seg  : out std_logic_vector(6 downto 0);
        an   : out std_logic_vector(3 downto 0);
        dp   : out std_logic
    );
end glue;

architecture Behavioral of glue is
    component seven_seg_decoder
        port (
            sw1  : in std_logic_vector(3 downto 0);
            seg1 : out std_logic_vector(6 downto 0)
        );
    end component;

    component modulo 
        generic (
            modulo_n : integer := 10
        );
        port (
            clk   : in std_logic;
            clr   : in std_logic;
            pause : in std_logic;
            O     : out integer;
            bit_O : out std_logic
        );
    end component;

    component tim
        port (
            clk : in std_logic;
            AN  : out std_logic_vector(3 downto 0);
            S   : out std_logic_vector(1 downto 0);
            dp  : out std_logic
        );
    end component;

    component mux
        port (
            A : in integer;
            B : in integer;
            C : in integer;
            D : in integer;
            S : in std_logic_vector(1 downto 0);
            O : out std_logic_vector(3 downto 0)
        );
    end component;

    component smooth
        port (
            clk     : in std_logic;
            btn_in  : in std_logic;
            btn_out : out std_logic
        );
    end component;

    -- Chained clock bits for modulos
    signal slow_to_ms   : std_logic                    := '0';
    signal ms_to_sec1   : std_logic                    := '0';
    signal sec1_to_sec2 : std_logic                    := '0';
    signal sec2_to_m    : std_logic                    := '0';
    signal ghost_bit    : std_logic                    := '0';

    -- Output of modulos
    signal modulo_1e7_out   : integer                      := 0;
    signal ms_O         : integer                      := 0;
    signal s1_O         : integer                      := 0;
    signal s2_O         : integer                      := 0;
    signal m_O          : integer                      := 0;

    signal mux_sel      : std_logic_vector(1 downto 0) := "00";

    signal mux_o        : std_logic_vector(3 downto 0) := "0000";
    signal btnL_p       : std_logic                    := '0';
    signal is_paused    : std_logic                    := '1';

    signal deb_s        : std_logic                    := '0';
    signal deb_p        : std_logic                    := '0';
    signal deb_r        : std_logic                    := '0';

begin

    -- Pause Button Register
    pause_register : process (clk, deb_s, deb_p, deb_r)
    begin
        if (rising_edge(clk)) then
            if deb_s = '1' then
                is_paused <= '0';
            end if;

            if (deb_p = '1' or deb_r = '1') then
                is_paused <= '1';
            end if;
        end if;
    end process;

    -- Debounce all the button inputs
    start_debouncer : smooth port map(
        clk     => clk,
        btn_in  => btnL,
        btn_out => deb_s
    );

    pause_debouncer : smooth port map(
        clk     => clk,
        btn_in  => btnC,
        btn_out => deb_p
    );

    reset_debouncer : smooth port map(
        clk     => clk,
        btn_in  => btnR,
        btn_out => deb_r
    );

    modulo_1e7_clock_slower : modulo
    generic map(
        modulo_n => 1e7
    )
    port map(
        clk   => clk,
        clr   => deb_r,
        pause => is_paused,
        O     => modulo_1e7_out,
        bit_O => slow_to_ms
    );

    modulo_10_for_ms : modulo
    generic map(
        modulo_n => 10
    )
    port map(
        clk   => slow_to_ms,
        clr   => deb_r,
        pause => is_paused,
        O     => ms_O,
        bit_O => ms_to_sec1
    );

    modulo_10_for_s : modulo
    generic map(
        modulo_n => 10
    )
    port map(
        clk   => ms_to_sec1,
        clr   => deb_r,
        pause => is_paused,
        O     => s1_O,
        bit_O => sec1_to_sec2
    );

    modulo_6_for_ms : modulo
    generic map(
        modulo_n => 6
    )
    port map(
        clk   => sec1_to_sec2,
        clr   => deb_r,
        pause => is_paused,
        O     => s2_O,
        bit_O => sec2_to_m
    );

    modulo_10_for_m : modulo
    generic map(
        modulo_n => 10
    )
    port map(
        clk   => sec2_to_m,
        clr   => deb_r,
        pause => is_paused,
        O     => m_O,
        bit_O => ghost_bit
    );

    tim_label : tim port map(
        clk => clk,
        an  => AN,
        S   => mux_sel,
        dp  => dp
    );

    mux_label : mux port map(
        A => ms_O,
        B => s1_O,
        C => s2_O,
        D => m_O,
        
        O => mux_o,

        S => mux_sel
    );

    seven_seg_label : seven_seg_decoder port map(
        sw1  => mux_o,
        seg1 => seg
    );

end Behavioral;