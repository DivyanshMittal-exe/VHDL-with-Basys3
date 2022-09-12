comp:
	ghdl -a comparator.vhd TB_comparator.vhd
	ghdl -r TB --wave=wave.ghw
	gtkwave wave.ghw

ram:
	ghdl -a ram.vhd TB_ram.vhd
	ghdl -r TB --wave=wave.ghw
	gtkwave wave.ghw