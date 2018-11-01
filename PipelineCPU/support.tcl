proc compile_all {} {
	vcom -work work cpu.vhd
	vcom -work work mux.vhd
	vcom -work work reg.vhd
}