proc compile_all {} {
	vcom -work work ALU1.vhd
	vcom -work work ALU32.vhd
	vcom -work work ALUControl.vhd
	vcom -work work And2.vhd
	vcom -work work Control.vhd
	vcom -work work CPU.vhd
	vcom -work work DataMemory.vhd
	vcom -work work InstMemory.vhd
	vcom -work work mux32.vhd
	vcom -work work MUX32_2.vhd
	vcom -work work MUX32_4.vhd
	vcom -work work mux5.vhd
	vcom -work work NOR32.vhd
	vcom -work work PC.vhd
	vcom -work work reg.vhd
	vcom -work work reg1.vhd
	vcom -work work registers.vhd
	vcom -work work ShiftLeft2.vhd
	vcom -work work ShiftLeft2Jump.vhd
	vcom -work work SignExtend.vhd
}

proc sim_start {} {
    vsim work.cpu
    add wave sim:/cpu/clk
    add wave sim:/cpu/NextPC
    add wave sim:/cpu/PC
    add wave sim:/cpu/Instruction
    add wave sim:/cpu/DMemory/memFile
    add wave sim:/cpu/Register1/regFile
	sim_set
}

proc sim_reset {} {
	restart
	sim_set
}

proc sim_set {} {
    force -freeze sim:/cpu/clk 1 0, 0 {50 ns} -r 100
    force -freeze sim:/cpu/NextPC 32'h0 0 -cancel 110
}


proc sim_run {} {
    run 1000ns
}

