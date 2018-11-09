proc compileall {} {
	vcom -work work ALU1.vhd
	vcom -work work ALU32.vhd
	vcom -work work ALUControl.vhd
	vcom -work work Control.vhd
	vcom -work work CPU.vhd
	vcom -work work DataMemory.vhd
	vcom -work work IF_Stage.vhd
	vcom -work work InstMemory.vhd
	vcom -work work mux.vhd
	vcom -work work NOR32.vhd
	vcom -work work PC.vhd
	vcom -work work reg.vhd
	vcom -work work reg1.vhd
	vcom -work work registers.vhd
	vcom -work work ShiftLeft2.vhd
	vcom -work work ShiftLeft2Jump.vhd
	vcom -work work SignExtend.vhd
}
proc simset {} {
	force -freeze sim:/cpu/clk 1 0, 0 {50 ns} -r 100ns
	force -freeze sim:/cpu/IFStage/NextPC 32'h0 0 -cancel 20
	mem load -filltype value -fillradix hexadecimal -filldata {00} /cpu/IFStage/InstMem/memFile
}
proc simreset {} {
	restart
	simset
}
proc simstart {} {
	vsim work.cpu
	add wave -group "CPU Clock" -color "Grey60" -label "Clock" "sim:/cpu/clk"
	add wave -group "IF Stage" -color "White" -label "Next PC" "sim:/cpu/IFStage/NextPC"
	add wave -group "IF Stage" -color "White" -label "PC" "sim:/cpu/IFStage/PC"
	add wave -group "IF Stage" -color "White" -label "Instruction" "sim:/cpu/IFStage/Instruction"
	add wave -group "IF Stage" -color "White" -label "PC + 4" "sim:/cpu/IFStage/PCPlus4"
	simset
}
proc simloadexample {} {
	simreset
	mem load -filltype value -fillradix hexadecimal -startaddress 0 -endaddress 15 -filldata {8C 08 00 00 8C 09 00 04 01 09 50 20 AC 0A 00 08} /cpu/IFStage/InstMem/memFile
}
proc simrun {} {
	run 2200ns
}