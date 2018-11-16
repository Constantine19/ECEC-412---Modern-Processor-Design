proc init {} {
	vlib work
}
proc compileall {} {
	vcom -work work reg.vhd
}