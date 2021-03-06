proc compileall {} {
	vcom -work work ALU1.vhd
	vcom -work work ALU32.vhd
	vcom -work work ALUControl.vhd
	vcom -work work Control.vhd
	vcom -work work CPU.vhd
	vcom -work work DataMemory.vhd
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
	force -freeze sim:/cpu/NextPC 32'h0 0 -cancel 10
	mem load -filltype value -fillradix hexadecimal -startaddress 0 -endaddress 0 -filldata {00000000} /cpu/Registers1/regFile
	mem load -filltype value -fillradix hexadecimal -startaddress 8 -endaddress 10 -filldata {00000000 00000004 00000004} /cpu/Registers1/regFile
	mem load -filltype value -fillradix hexadecimal -startaddress 20 -endaddress 23 -filldata {0000000C 00000005 00000008 00000003} /cpu/Registers1/regFile
	mem load -filltype value -fillradix hexadecimal -startaddress 29 -endaddress 29 -filldata {000000F8} /cpu/Registers1/regFile
	mem load -filltype value -fillradix hexadecimal -startaddress 0 -endaddress 7 -filldata {00 00 00 04 00 00 00 08} /cpu/DataMem/memFile
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
	add wave -group "Memory Files" -color "Medium Orchid" -label "Data Memory" "sim:/cpu/DataMem/memFile"
	add wave -group "Memory Files" -color "Medium Orchid" -label "Registers" "sim:/cpu/Registers1/regFile"
	add wave -group "Control Signals" -color "Orange" -label "Opcode" "sim:/cpu/Controller/Opcode"
	add wave -group "Control Signals" -color "Orange" -label "RegDst" "sim:/cpu/Controller/RegDst"
	add wave -group "Control Signals" -color "Orange" -label "Branch" "sim:/cpu/Controller/Branch"
	add wave -group "Control Signals" -color "Orange" -label "MemRead" "sim:/cpu/Controller/MemRead"
	add wave -group "Control Signals" -color "Orange" -label "MemtoReg" "sim:/cpu/Controller/MemtoReg"
	add wave -group "Control Signals" -color "Orange" -label "MemWrite" "sim:/cpu/Controller/MemWrite"
	add wave -group "Control Signals" -color "Orange" -label "ALUSrc" "sim:/cpu/Controller/ALUSrc"
	add wave -group "Control Signals" -color "Orange" -label "RegWrte" "sim:/cpu/Controller/RegWrite"
	add wave -group "Control Signals" -color "Orange" -label "Jump" "sim:/cpu/Controller/Jump"
	add wave -group "Control Signals" -color "Orange" -label "ALUOp" "sim:/cpu/Controller/ALUOp"
	add wave -group "Control Signals" -color "Orange" -label "StackOp" "sim:/cpu/Controller/StackOp"
	add wave -group "Control Signals" -color "Orange" -label "StackPushPop" "sim:/cpu/Controller/StackPushPop"
	add wave -group "Control Signals" -color "Orange" -label "StackPop" "sim:/cpu/StackPop"
	add wave -group "Register Data" -color "Cyan" -label "Read Address 1" "sim:/cpu/Registers1/RR1"
	add wave -group "Register Data" -color "Cyan" -label "Read Address 2" "sim:/cpu/Registers1/RR2"
	add wave -group "Register Data" -color "Cyan" -label "Write Address" "sim:/cpu/Registers1/WR"
	add wave -group "Register Data" -color "Cyan" -label "Write Data" "sim:/cpu/Registers1/WD"
	add wave -group "Register Data" -color "Cyan" -label "Write Stack" "sim:/cpu/Registers1/WS"
	add wave -group "Register Data" -color "Cyan" -label "Read Data 1" "sim:/cpu/Registers1/RD1"
	add wave -group "Register Data" -color "Cyan" -label "Read Data 2" "sim:/cpu/Registers1/RD2"
	add wave -group "Tertiary Signals" -color "Green" -label "Sign Extended Value" "sim:/cpu/MakeImmediate/y"
	add wave -group "Tertiary Signals" -color "Green" -label "Alu Control" "sim:/cpu/ALUControl1/Operation"
	add wave -group "Main ALU" -color "Turquoise" -label "Input A" "sim:/cpu/MainALU/a"
	add wave -group "Main ALU" -color "Turquoise" -label "Input B" "sim:/cpu/MainALU/b"
	add wave -group "Main ALU" -color "Turquoise" -label "Result" "sim:/cpu/MainALU/Result"
	add wave -group "Main ALU" -color "Turquoise" -label "Zero" "sim:/cpu/MainALU/Zero"
	simset
}
proc simloadexample1 {} {
	simreset
	mem load -filltype value -fillradix hexadecimal -startaddress 0 -endaddress 15 -filldata {8C 08 00 00 8C 09 00 04 01 09 50 20 AC 0A 00 08} /cpu/InstMem/memFile
}
proc simloadexample2 {} {
	simreset
	mem load -filltype value -fillradix hexadecimal -startaddress 0 -endaddress 7 -filldata {EB 00 00 04 EC 08 00 00} /cpu/InstMem/memFile
}
proc simrun {} {
	run 500ns
}