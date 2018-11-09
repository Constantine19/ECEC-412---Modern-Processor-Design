proc compileall {} {
	vcom -work work ALU1.vhd
	vcom -work work ALU32.vhd
	vcom -work work ALUControl.vhd
	vcom -work work Control.vhd
	vcom -work work CPU.vhd
	vcom -work work DataMemory.vhd
	vcom -work work EX_Stage.vhd
	vcom -work work ID_Stage.vhd
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
	mem load -filltype value -fillradix hexadecimal -startaddress 0 -endaddress 0 -filldata {00000000} /cpu/IDStage/Registers1/regFile
	mem load -filltype value -fillradix hexadecimal -startaddress 8 -endaddress 10 -filldata {00000000 00000004 00000004} /cpu/IDStage/Registers1/regFile
	mem load -filltype value -fillradix hexadecimal -startaddress 20 -endaddress 23 -filldata {0000000C 00000005 00000008 00000003} /cpu/IDStage/Registers1/regFile
	mem load -filltype value -fillradix hexadecimal -startaddress 29 -endaddress 29 -filldata {000000F8} /cpu/IDStage/Registers1/regFile
	mem load -filltype value -fillradix hexadecimal -filldata {00} /cpu/IFStage/InstMem/memFile
}
proc simreset {} {
	restart
	simset
}
proc simstart {} {
	vsim work.cpu
	add wave -group "CPU Clock" -color "Grey60" -label "Clock" "sim:/cpu/clk"
	add wave -group "Mem Files" -color "Magenta" -label "Register" "/cpu/IDStage/Registers1/regFile"
	add wave -group "IF Stage" -color "White" -label "Next PC" "sim:/cpu/IFStage/NextPC"
	add wave -group "IF Stage" -color "White" -label "PC" "sim:/cpu/IFStage/PC"
	add wave -group "IF Stage" -color "White" -label "Instruction" "sim:/cpu/IFStage/Instruction"
	add wave -group "IF Stage" -color "White" -label "PC + 4" "sim:/cpu/IFStage/PCPlus4"
	add wave -group "ID Stage" -color "Orange" -label "PC + 4 input" "sim:/cpu/IDStage/PCPlus4In"
	add wave -group "ID Stage" -color "Orange" -label "Instruction" "sim:/cpu/IDStage/Instruction"
	add wave -group "ID Stage" -color "Orange" -label "Read Address 1" "sim:/cpu/IDStage/Registers1/RR1"
	add wave -group "ID Stage" -color "Orange" -label "Read Address 2" "sim:/cpu/IDStage/Registers1/RR2"
	add wave -group "ID Stage" -color "Orange" -label "WriteBack Address" "sim:/cpu/IDStage/WBR"
	add wave -group "ID Stage" -color "Orange" -label "WriteBack Write Data" "sim:/cpu/IDStage/WD"
	add wave -group "ID Stage" -color "Orange" -label "WriteBack Stack Data" "sim:/cpu/IDStage/WS"
	add wave -group "ID Stage" -color "Orange" -label "Read Data 1" "sim:/cpu/IDStage/RD1"
	add wave -group "ID Stage" -color "Orange" -label "Read Data 2" "sim:/cpu/IDStage/RD2"
	add wave -group "ID Stage" -color "Orange" -label "Write Address" "sim:/cpu/IDStage/WR"
	add wave -group "EX Stage" -color "Turquoise" -label "Input A" "sim:/cpu/EXStage/MainALU/a"
	add wave -group "EX Stage" -color "Turquoise" -label "Input B" "sim:/cpu/EXStage/MainALU/b"
	add wave -group "EX Stage" -color "Turquoise" -label "Result" "sim:/cpu/EXStage/MainALU/Result"
	add wave -group "EX Stage" -color "Turquoise" -label "Zero" "sim:/cpu/EXStage/MainALU/Zero"
	simset
}
proc simloadexample {} {
	simreset
	mem load -filltype value -fillradix hexadecimal -startaddress 0 -endaddress 15 -filldata {8C 08 00 00 8C 09 00 04 01 09 50 20 AC 0A 00 08} /cpu/IFStage/InstMem/memFile
}
proc simrun {} {
	run 2200ns
}