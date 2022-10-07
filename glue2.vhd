library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity glue is
    generic (
        file_name : string := "file_4.mif"
    );
    port (
        clk : in std_logic;
        seg : out std_logic_vector(6 downto 0);
        an  : out std_logic_vector(3 downto 0)
    );
end glue;

architecture Behavioral of glue is
    component modulo
	   generic(
		  modulo_n : integer := 100
	   );
	   port (
		  clk : in std_logic;
		  O : out integer;
	      bit_O : out std_logic
	   );
    end component;
	
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
            image_size      : integer := 51914;
            image_file_name : string  := file_name
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
            data_width : integer := 16;
            ram_size   : integer := 1024

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
            ram_addr         : out integer := 0;
            rom_re           : out std_logic;
            ram_we           : out std_logic;
            ram_re           : out std_logic;
            mac_controler    : out std_logic;

            ram_mux          : out std_logic_vector(1 downto 0);
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

    signal ram_addr         : integer := 0;
    signal rom_addr         : integer := 0;
    signal ram_re           : std_logic;
    signal rom_re           : std_logic;
    signal ram_we           : std_logic;

    signal rom_out          : std_logic_vector(7 downto 0);
    signal ram_out          : std_logic_vector(15 downto 0);

    signal shifted_out      : std_logic_vector(15 downto 0);

    signal ram_in           : std_logic_vector(15 downto 0);
    signal mac_out          : std_logic_vector(15 downto 0);

    signal prediction       : integer;

    signal mac_controler    : std_logic                    := '0';
    signal ram_mux          : std_logic_vector(1 downto 0) := "00";
    signal ten_to_one_index : integer                      := 0;
    signal shifter_inp      : std_logic_vector(15 downto 0);
    signal relu_out         : std_logic_vector(15 downto 0);

    signal prediction_slv   : std_logic_vector(3 downto 0);
    signal prediction_uns  : unsigned(3 downto 0);
    signal ram_addr_slv     : std_logic_vector(9 downto 0);
    signal rom_addr_slv     : std_logic_vector(15 downto 0);

    signal clk0 : std_logic := '0';
    signal num : integer := 0;
begin

    prediction_slv <= std_logic_vector(to_unsigned(prediction, 4));
    ram_addr_slv   <= std_logic_vector(to_unsigned(ram_addr, 10)) when ram_addr >= 0 else "0000000000";
    rom_addr_slv   <= std_logic_vector(to_unsigned(rom_addr, 16));

    modulo_1 : modulo
    generic map(
		modulo_n => 100
	)
    port map(
		clk => clk,
		O => num,
		bit_O => clk0
	);
	

    fsm_mapper : fsm port map(

        clk              => clk0,
        rom_addr         => rom_addr,
        ram_addr         => ram_addr,
        rom_re           => rom_re,
        ram_we           => ram_we,
        ram_re           => ram_re,
        mac_controler    => mac_controler,

        ram_mux          => ram_mux,
        ten_to_one_index => ten_to_one_index
    );

    rom_mapper : rom_mem
    generic map(
        addr_width      => 16,
        data_width      => 8,
        image_size      => 51914,
        image_file_name => file_name
    )
    port map(
        addr => rom_addr_slv,
        clk  => clk0,
        re   => rom_re,
        dout => rom_out
    );

    ram_in <= "00000000" & rom_out when ram_mux = "00" else
        relu_out when ram_mux = "01" else
        shifted_out;


    ram_data_mapper : data_mem
    generic map(
        addr_width => 10,
        data_width => 16,
        ram_size   => 1024
    )
    port map(
        clk  => clk0,
        we   => ram_we,
        re   => ram_re,
        addr => ram_addr_slv,
        din  => ram_in,
        dout => ram_out
    );

    mac_mapper : mac port map(
        din1  => rom_out,
        din2  => ram_out,
        clk   => clk0,
        cntrl => mac_controler,
        dout  => mac_out
    );

    shifter_inp <= std_logic_vector(signed(rom_out) + signed(mac_out));

    shifter_mapper : shifter
    port map(
        inp  => shifter_inp,
        outp => shifted_out
    );

    relu_mapper : relu
    generic map(
        inp_width => 16
    )
    port map(
        inp  => shifted_out,
        outp => relu_out
    );
    ten_to_one_mapper : ten_to_one
    port map(
        clk       => clk0,
        value     => ram_out,
        index     => ten_to_one_index,
        max_index => prediction
    );
    an <= "1110";

    seven_seg_label : seven_seg_decoder port map(
        sw1  => prediction_slv(3 downto 0),
        seg1 => seg
    );

end Behavioral;
