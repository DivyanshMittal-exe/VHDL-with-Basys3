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

    component mod6
        port (
            clk   : in std_logic;
            clr   : in std_logic;
            pause : in std_logic;
            O     : out std_logic_vector(3 downto 0);
            bit_O : out std_logic
        );
    end component;

    component mod10
        port (
            clk   : in std_logic;
            clr   : in std_logic;
            pause : in std_logic;
            O     : out std_logic_vector(3 downto 0);
            bit_O : out std_logic
        );
    end component;

    component tim
        port (
            clk : in std_logic;
            AN  : out std_logic_vector(3 downto 0);
            S   : out std_logic_vector(1 downto 0);
            dp : out std_logic
        );
    end component;

    component mux
        port (
            A : in std_logic_vector(3 downto 0);
            B : in std_logic_vector(3 downto 0);
            C : in std_logic_vector(3 downto 0);
            D : in std_logic_vector(3 downto 0);  
            S : in std_logic_vector(1 downto 0);
            O : out std_logic_vector(3 downto 0)
        );
    end component;

    component mod107
        port (
            clk   : in std_logic;
            clr   : in std_logic;
            pause : in std_logic;
            -- O: out std_logic_vector(3 downto 0) ;
            bit_O : out std_logic
        );
    end component;

    component smooth
        port (
            clk : in std_logic;
            btn_in  : in std_logic;
            btn_out : out std_logic
        );
    end component;

    signal strt : std_logic := '0';
     signal pppp : std_logic := '0';
--    signal pause : std_logic := '0';
    signal res : std_logic := '0';
    signal ctoms : std_logic := '0';
    signal mstos1 : std_logic := '0';
    signal s1tos2 : std_logic := '0';
    signal s2tom : std_logic := '0';
    signal ghost : std_logic := '0';
    signal ms_O : std_logic_vector(3 downto 0) ;
    signal s1_O : std_logic_vector(3 downto 0) ;
    signal s2_O : std_logic_vector(3 downto 0) ;
    signal m_O : std_logic_vector(3 downto 0) ;

    signal mux_sel: std_logic_vector(1 downto 0) := "00" ;

    signal mux_a : std_logic_vector(3 downto 0) := "0000" ;
    signal mux_b : std_logic_vector(3 downto 0) := "0000" ;
    signal mux_c : std_logic_vector(3 downto 0) := "0000" ;
    signal mux_d : std_logic_vector(3 downto 0) := "0000" ;
    signal mux_o : std_logic_vector(3 downto 0) := "0000" ;
    signal btnL_p : std_logic := '0';

    signal is_paused: std_logic := '1';

    signal deb_s: std_logic := '0';
    signal deb_p: std_logic := '0';
    signal deb_r: std_logic := '0';


begin
    
    -- L is start , C is pause , R is reset

    paus_but : process( clk,deb_s,deb_p,deb_r )
    begin
        if (rising_edge(clk)) then
                if  deb_s = '1' then 
                    is_paused <= '0';
                end if;
            
                if (deb_p = '1' or deb_r = '1') then 
                    is_paused <=  '1';
                end if;    
        end if;


        
    end process ;

    s_label : smooth port map(
        clk => clk,
        btn_in => btnL,
        btn_out => deb_s
    );

    p_label : smooth port map(
        clk => clk,
        btn_in => btnC,
        btn_out => deb_p 
    );

    r_label : smooth port map(
        clk => clk,
        btn_in => btnR,
        btn_out => deb_r
    );

    mod107_label : mod107 port map(
        clk => clk,
        clr => deb_r ,
        pause => is_paused,
        bit_O => ctoms
    );

    mod10_1_label : mod10 port map(
        clk => ctoms, 
        clr => deb_r ,
        pause => is_paused,
        O => ms_O ,
        bit_O => mstos1 
    );

    mod10_2_label : mod10 port map(
        clk => mstos1,
        clr => deb_r,
        pause => is_paused,
        O => s1_O,
        bit_O => s1tos2
    );

    mod6_3_label : mod6 port map(
        clk => s1tos2,
        clr => deb_r,
        pause => is_paused,
        O => s2_O,
        bit_O => s2tom
    );

    mod10_4_label : mod10 port map(
        clk => s2tom ,
        clr => deb_r ,
        pause => is_paused,
        O => m_O ,
        bit_O => ghost 
    );

    tim_label : tim port map(
        clk => clk,
        an => AN,
        S => mux_sel,
        dp => dp
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
        sw1 => mux_o,
        seg1 => seg
    );

end Behavioral;