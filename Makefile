comp:
	ghdl -a comparator.vhd TB_comparator.vhd
	ghdl -r TB --wave=wave.ghw
	gtkwave wave.ghw

ram:
	ghdl -a ram.vhd TB_ram.vhd
	ghdl -r TB --wave=wave.ghw
	gtkwave wave.ghw

mac:
	ghdl -a mac.vhd tb_mac.vhd
	ghdl -r tb --wave=wave.ghw
	gtkwave wave.ghw

reg:
	ghdl -a register.vhd tb_register.vhd
	ghdl -r TB --wave=wave.ghw
	gtkwave wave.ghw

shift:
	ghdl -a shifter.vhd tb_shifter.vhd
	ghdl -r TB --wave=wave.ghw
	gtkwave wave.ghw
