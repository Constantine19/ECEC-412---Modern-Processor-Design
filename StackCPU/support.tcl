proc compileall {} {
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
proc simset {} {
	force -freeze sim:/cpu/clk 1 0, 0 {50 ns} -r 100
	force -freeze sim:/cpu/NextPC 32'h0 0 -cancel 10
	mem load -filltype value -fillradix hexadecimal -startaddress 0 -endaddress 0 -filldata {00000000} /cpu/Register1/regFile
	mem load -filltype value -fillradix hexadecimal -startaddress 8 -endaddress 10 -filldata {00000000 00000004 00000004} /cpu/Register1/regFile
	mem load -filltype value -fillradix hexadecimal -startaddress 20 -endaddress 23 -filldata {0000000C 00000005 00000008 00000003} /cpu/Register1/regFile
	mem load -filltype value -fillradix hexadecimal -startaddress 0 -endaddress 7 -filldata {00 00 00 04 00 00 00 08} /cpu/DMemory/memFile
	mem load -filltype value -fillradix hexadecimal -filldata {00} /cpu/InstMem/memFile
}
proc simreset {} {
	restart
	simset
}
proc simstart {} {
	vsim work.cpu
	add wave -group "Instruction" -color "Grey60" -label "Clock" "sim:/cpu/clk"
	add wave -group "Instruction" -color "Grey60" -label "Next PC" "sim:/cpu/NextPC"
	add wave -group "Instruction" -color "Grey60" -label "PC" "sim:/cpu/PC"
	add wave -group "Instruction" -color "Grey60" -label "Instruction" "sim:/cpu/Instruction"
	add wave -group "Memory Files" -color "Medium Orchid" -label "Data Memory" "sim:/cpu/DMemory/memFile"
	add wave -group "Memory Files" -color "Medium Orchid" -label "Registers" "sim:/cpu/Register1/regFile"
	add wave -group "Control Signals" -color "Orange" -label "Opcode" "sim:/cpu/Control1/Opcode"
	add wave -group "Control Signals" -color "Orange" -label "RegDst" "sim:/cpu/Control1/RegDst"
	add wave -group "Control Signals" -color "Orange" -label "Branch" "sim:/cpu/Control1/Branch"
	add wave -group "Control Signals" -color "Orange" -label "MemRead" "sim:/cpu/Control1/MemRead"
	add wave -group "Control Signals" -color "Orange" -label "MemtoReg" "sim:/cpu/Control1/MemtoReg"
	add wave -group "Control Signals" -color "Orange" -label "MemWrite" "sim:/cpu/Control1/MemWrite"
	add wave -group "Control Signals" -color "Orange" -label "ALUSrc" "sim:/cpu/Control1/ALUSrc"
	add wave -group "Control Signals" -color "Orange" -label "RegWrte" "sim:/cpu/Control1/RegWrite"
	add wave -group "Control Signals" -color "Orange" -label "Jump" "sim:/cpu/Control1/Jump"
	add wave -group "Control Signals" -color "Orange" -label "AluOp" "sim:/cpu/Control1/ALUOp"
	add wave -group "Control Signals" -color "Orange" -label "StackOps" "sim:/cpu/Control1/StackOps"
	add wave -group "Register Data" -color "Cyan" -label "Read Address 1" "sim:/cpu/Register1/RR1"
	add wave -group "Register Data" -color "Cyan" -label "Read Address 2" "sim:/cpu/Register1/RR2"
	add wave -group "Register Data" -color "Cyan" -label "Write Address" "sim:/cpu/Register1/WR"
	add wave -group "Register Data" -color "Cyan" -label "Write Data" "sim:/cpu/Register1/WD"
	add wave -group "Register Data" -color "Cyan" -label "Write Stack" "sim:/cpu/Register1/WS"
	add wave -group "Register Data" -color "Cyan" -label "Read Data 1" "sim:/cpu/Register1/RD1"
	add wave -group "Register Data" -color "Cyan" -label "Read Data 2" "sim:/cpu/Register1/RD2"
	simset
}
proc simloadexample1 {} {
	simreset
	mem load -filltype value -fillradix hexadecimal -startaddress 0 -endaddress 15 -filldata {8D 00 00 00 8D 20 00 04 01 49 10 20 AD 40 00 08} /cpu/InstMem/memFile
}
proc simloadexample2 {} {
	simreset
	mem load -filltype value -fillradix hexadecimal -startaddress 0 -endaddress 7 -filldata {EB 00 00 04 ED 00 00 00} /cpu/InstMem/memFile
}
proc simrun {} {
	run 400ns
}