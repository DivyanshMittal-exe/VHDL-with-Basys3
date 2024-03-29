all:
	ghdl -a -fsynopsys  comparator.vhd 7_seg_decoder.vhd fsm.vhd mac.vhd ram.vhd register.vhd rom_mem.vhd shifter.vhd ten_to_one.vhd glue.vhd tb.vhd
	ghdl -r TB_main --wave=wave.ghw --max-stack-alloc=0
	gtkwave wave.ghw

comp:
	ghdl -a comparator.vhd tb_comparator.vhd
	ghdl -r TB_Comp --wave=wave.ghw
	gtkwave wave.ghw

ram:
	ghdl -a ram.vhd tb_ram.vhd
	ghdl -r TB_Ram --wave=wave.ghw
	gtkwave wave.ghw

mac:
	ghdl -a mac.vhd tb_mac.vhd
	ghdl -r TB_Mac --wave=wave.ghw
	gtkwave wave.ghw

reg:
	ghdl -a register.vhd tb_register.vhd
	ghdl -r TB_Reg --wave=wave.ghw
	gtkwave wave.ghw

shift:
	ghdl -a shifter.vhd tb_shifter.vhd
	ghdl -r TB_Shift --wave=wave.ghw
	gtkwave wave.ghw
