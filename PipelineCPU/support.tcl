proc compile_all {} {
	vcom -work work ALU1.vhd
	vcom -work work ALU32.vhd
	vcom -work work cpu.vhd
	vcom -work work if_reg.vhd
	vcom -work work InstMemory.vhd
	vcom -work work mux.vhd
	vcom -work work NOR32.vhd
	vcom -work work reg.vhd
}