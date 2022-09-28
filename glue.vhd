library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity glue is
    port (
        clk  : in std_logic;
        seg  : out std_logic_vector(6 downto 0);
        an   : out std_logic_vector(3 downto 0)
    );
end glue;

architecture Behavioral of glue is
    component seven_seg_decoder
        port (
            sw1  : in std_logic_vector(3 downto 0);
            seg1 : out std_logic_vector(6 downto 0)
        );
    end component;

    component rom_mem
        generic (
            addr_width : integer := 16;
            data_width : integer := 16;
            -- 1024(784 used only) + 50816 + 74 is the size
            image_size : integer := 51914;
            image_file_name : string := "imgdata.mif"
        );

        port(
            addr : in std_logic_vector((addr_width-1) downto 0);
            clk : in std_logic;
            re : in std_logic;
            dout : out std_logic_vector((data_width-1) downto 0)
          );
    end component;

    component data_mem 
        generic(
            addr_width : integer := 16;
            data_width : integer := 16
    
        );
        port (
            clk : in std_logic;
            we    : in std_logic;
            addr : in std_logic_vector((addr_width-1) downto 0);
            din    : in std_logic_vector((data_width-1) downto 0);
            dout    : out std_logic_vector((data_width-1) downto 0)
    
        );
    end component;

    component FSM
        port (
            reset       : in std_logic := '0';
            clk         : in std_logic;
            img_rom_addr : out integer := 0;
            img_ram_addr : out integer := 0;
            wt_rom_addr : out integer := 0;
            img_rom_re   : out std_logic;
            img_ram_we   : out std_logic;
            img_ram_re   : out std_logic;
            wt_rom_re   : out std_logic;
            mac_controler : out std_logic;
            layer_ram_addr : out integer;
            layer_ram_we : out std_logic;
    
            mac_mux : out std_logic;  
            do_i_relu : out std_logic;

        );
    end component;

    component mac is
        Port ( 
          din1 : in std_logic_vector(7 downto 0);
          din2 : in std_logic_vector(15 downto 0);
          clk : in std_logic;
          cntrl : in std_logic;
          dout : out std_logic_vector(15 downto 0)
        );
    end component;

    component relu is
        generic(
          inp_width : integer := 16
        );
        port(
          inp : in std_logic_vector((inp_width-1) downto 0);
          outp : out std_logic_vector((inp_width-1) downto 0)
        );
      end component;

    signal img_ram_addr: std_logic_vector(15 downto 0) ;
    signal img_rom_addr: std_logic_vector(15 downto 0) ;
    signal img_ram_re : std_logic;
    signal img_rom_re : std_logic;
    signal img_ram_we : std_logic;

    signal img_rom_out: std_logic_vector(15 downto 0) ;
    signal img_ram_out: std_logic_vector(15 downto 0) ;

    signal do_i_relu_out : std_logic_vector(15 downto 0) ;

    signal wt_rom_addr: std_logic_vector(15 downto 0) ;
    signal wt_rom_re : std_logic;

    signal wt_rom_out: std_logic_vector(7 downto 0) ;

    signal mac_out: std_logic_vector(7 downto 0) ;

begin

    fsm_mapper : fsm port map(
        reset  => '0',
        clk => clk,

    );

    img_rom_mapper: rom_mem
        generic map(
            addr_width => 16,
            data_width  => 16
            -- 1024(784 used only) + 50816 + 74 is the size
            image_size => 784
            image_file_name : string := "imgdata_digit7.mif"
        );

        port map(
            addr => img_rom_addr,
            clk => clk,
            re => img_rom_re,
            dout => img_rom_out
          );

    wt_rom_mapper: rom_mem
        generic map(
            addr_width => 16,
            data_width  => 8
            -- 1024(784 used only) + 50816 + 74 is the size
            image_size => 50890
            image_file_name : string := "weights_bias.mif"
        );

        port map(
            addr => wt_rom_addr,
            clk => clk,
            re => wt_rom_re,
            dout => wt_rom_out
          );
    




    mac_out_mapper: data_mem 
    generic map(
        addr_width => 16;
        data_width => 16

    );
    port (
        clk => clk,
        we  => img_ram_we,
        addr => img_ram_addr,
        din  => img_rom_out,
        dout => img_ram_out

    );

    mac_mapper: mac port map ( 
          din1 => wt_rom_out,
          din2 => img_ram_out when mac_mux = '0' else layer_ram_out,
          clk => clk,
          cntrl => mac_controler,
          dout => mac_out
        );
    
     relu_mapper: relu
        generic map(
            inp_width => 16
        );
        port map(
            inp => mac_out;
            outp => relu_out;
        );

    do_i_relu_out <= std_logic_vector(shift_right(unsigned(relu_out), 5)) when do_i_relu = '1' else
                    mac_out;

    layer_ram_mapper: data_mem 
        generic map(
            addr_width => 16;
            data_width => 16

        );
        port (
            clk => clk,
            we  => layer_ram_we,
            addr => layer_ram_addr,
            din  => do_i_relu_out,
            dout => layer_ram_out

        );

    an <= "1110";

    seven_seg_label : seven_seg_decoder port map(
        sw1  => ,
        seg1 => seg
    );

end Behavioral;