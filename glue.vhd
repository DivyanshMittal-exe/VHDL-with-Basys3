library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity glue is
    port (
        clk : in std_logic;
        seg : out std_logic_vector(6 downto 0);
        an  : out std_logic_vector(3 downto 0)
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
            addr_width      : integer := 16;
            data_width      : integer := 16;
            -- 1024(784 used only) + 50816 + 74 is the size
            image_size      : integer := 784;
            image_file_name : string  := "imgdata.mif"
        );

        port (
            addr : in std_logic_vector((addr_width - 1) downto 0);
            clk  : in std_logic;
            re   : in std_logic;
            dout : out std_logic_vector((data_width - 1) downto 0)
        );
    end component;

    component data_mem
        generic (
            addr_width : integer := 16;
            data_width : integer := 16

        );
        port (
            clk  : in std_logic;
            we   : in std_logic;
            re   : in std_logic;
            addr : in std_logic_vector((addr_width - 1) downto 0);
            din  : in std_logic_vector((data_width - 1) downto 0);
            dout : out std_logic_vector((data_width - 1) downto 0)

        );
    end component;

    component FSM
        port (
            clk              : in std_logic;
            rom_addr         : out integer := 0;
            img_ram_addr     : out integer := 0;
            rom_re           : out std_logic;
            img_ram_we       : out std_logic;
            img_ram_re       : out std_logic;
            mac_controler    : out std_logic;
            layer_ram_addr   : out integer;
            layer_ram_we     : out std_logic;
            layer_ram_re     : out std_logic;

            mac_mux          : out std_logic;
            do_i_relu        : out std_logic;
            ten_to_one_index : out integer
        );
    end component;

    component mac is
        port (
            din1  : in std_logic_vector(7 downto 0);
            din2  : in std_logic_vector(15 downto 0);
            clk   : in std_logic;
            cntrl : in std_logic;
            dout  : out std_logic_vector(15 downto 0)
        );
    end component;

    component relu is
        generic (
            inp_width : integer := 16
        );
        port (
            inp  : in std_logic_vector((inp_width - 1) downto 0);
            outp : out std_logic_vector((inp_width - 1) downto 0)
        );
    end component;

    component shifter is
        port (
            inp  : in std_logic_vector(15 downto 0);
            outp : out std_logic_vector(15 downto 0)
        );
    end component;

    component ten_to_one is
        port (
            clk       : in std_logic;
            value     : in std_logic_vector(15 downto 0);
            index     : in integer;
            max_index : out integer
        );
    end component;

    signal img_ram_addr       : integer;
    signal rom_addr           : integer;
    signal img_ram_re         : std_logic;
    signal rom_re             : std_logic;
    signal img_ram_we         : std_logic;

    signal rom_out            : std_logic_vector(7 downto 0);
    signal img_ram_out        : std_logic_vector(7 downto 0);

    signal do_i_relu_out      : std_logic_vector(15 downto 0);
    signal shifted_out        : std_logic_vector(15 downto 0);
    signal layer_ram_addr     : integer;
    signal layer_ram_we       : std_logic;
    signal layer_ram_re       : std_logic;

    signal mac_in             : std_logic_vector(15 downto 0);
    signal mac_out            : std_logic_vector(15 downto 0);

    signal prediction         : integer   := 11;

    signal mac_controler      : std_logic := '0';
    signal mac_mux            : std_logic := '0';
    signal do_i_relu          : std_logic := '0';
    signal ten_to_one_index   : integer   := 0;
    signal relu_inp           : std_logic_vector(15 downto 0);
    signal relu_out           : std_logic_vector(15 downto 0);
    signal layer_ram_out      : std_logic_vector(15 downto 0);

    signal img_ram_addr_slv   : std_logic_vector(15 downto 0);
    signal rom_addr_slv       : std_logic_vector(15 downto 0);
    signal layer_ram_addr_slv : std_logic_vector(15 downto 0);
    signal prediction_slv     : std_logic_vector(3 downto 0);
begin

    img_ram_addr_slv   <= std_logic_vector(to_unsigned(img_ram_addr, 16));
    rom_addr_slv       <= std_logic_vector(to_unsigned(rom_addr, 16));
    layer_ram_addr_slv <= std_logic_vector(to_unsigned(layer_ram_addr, 16));
    prediction_slv     <= std_logic_vector(to_unsigned(prediction, 4));

    fsm_mapper : fsm port map(

        clk              => clk,
        rom_addr         => rom_addr,
        img_ram_addr     => img_ram_addr,
        rom_re           => rom_re,
        img_ram_we       => img_ram_we,
        img_ram_re       => img_ram_re,
        mac_controler    => mac_controler,
        layer_ram_addr   => layer_ram_addr,
        layer_ram_we     => layer_ram_we,
        layer_ram_re     => layer_ram_re,

        mac_mux          => mac_mux,
        do_i_relu        => do_i_relu,
        ten_to_one_index => ten_to_one_index
    );

    rom_mapper : rom_mem
    generic map(
        addr_width      => 16,
        data_width      => 8,
        image_size      => 51914,
        image_file_name => "file.mif"
    )
    port map(
        addr => rom_addr_slv,
        clk  => clk,
        re   => rom_re,
        dout => rom_out
    );
    img_data_mapper : data_mem
    generic map(
        addr_width => 16,
        data_width => 8
    )
    port map(
        clk  => clk,
        we   => img_ram_we,
        re   => img_ram_re,
        addr => img_ram_addr_slv,
        din  => rom_out,
        dout => img_ram_out

    );

    mac_in <= "00000000" & img_ram_out when mac_mux = '0' else
        layer_ram_out;

    mac_mapper : mac port map(
        din1  => rom_out,
        din2  => mac_in,
        clk   => clk,
        cntrl => mac_controler,
        dout  => mac_out
    );

    relu_inp <= std_logic_vector(signed(rom_out) + signed(mac_out));

    relu_mapper : relu
    generic map(
        inp_width => 16
    )
    port map(
        inp  => relu_inp,
        outp => relu_out
    );

    shifter_mapper : shifter
    port map(
        inp  => relu_out,
        outp => shifted_out
    );

    
    do_i_relu_out <= shifted_out when do_i_relu = '1' else
        std_logic_vector(signed(rom_out) + signed(mac_out));

    layer_ram_mapper : data_mem
    generic map(
        addr_width => 16,
        data_width => 16

    )
    port map(
        clk  => clk,
        we   => layer_ram_we,
        re   => layer_ram_re,
        addr => layer_ram_addr_slv,
        din  => do_i_relu_out,
        dout => layer_ram_out

    );

    ten_to_one_mapper : ten_to_one
    port map(
        clk       => clk,
        value     => layer_ram_out,
        index     => ten_to_one_index,
        max_index => prediction
    );
    an <= "1110";

    seven_seg_label : seven_seg_decoder port map(
        sw1  => prediction_slv,
        seg1 => seg
    );

end Behavioral;