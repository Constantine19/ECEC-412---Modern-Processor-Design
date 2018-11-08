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
	add wave -group Instruction -color Grey60 -label "Clock" sim:/cpu/clk
	add wave -group Instruction -color Grey60 -label "Next PC" sim:/cpu/NextPC
	add wave -group Instruction -color Grey60 -label "PC" sim:/cpu/PC
	add wave -group Instruction -color Grey60 -label "Instruction" Instruction
	add wave -group Memory Files -color Medium Orchid -label "Data Memory" sim:/cpu/DMemory/memFile
	add wave -group Memory Files -color Medium Orchid -label "Registers" sim:/cpu/Register1/regFile
	add wave -group Control Signals -color Orange -label "BranchOpResult" BranchOpResult
	add wave -group Control Signals -color Orange -label "RegDst" RegDst
	add wave -group Control Signals -color Orange -label "Branch" Branch
	add wave -group Control Signals -color Orange -label "MemRead" MemRead
	add wave -group Control Signals -color Orange -label "MemtoReg" MemtoReg
	add wave -group Control Signals -color Orange -label "MemWrite" MemWrite
	add wave -group Control Signals -color Orange -label "ALUSrc" ALUSrc
	add wave -group Control Signals -color Orange -label "RegWrte" RegWrte
	add wave -group Control Signals -color Orange -label "Jump" Jump
	add wave -group Control Signals -color Orange -label "AluOp" AluOp
	add wave -group Control Signals -color Orange -label "StackOps" StackOps
	sim_set
}

proc sim_reset {} {
	restart
	sim_set
}

proc sim_set {} {
	force -freeze sim:/cpu/clk 1 0, 0 {50 ns} -r 100
	force -freeze sim:/cpu/NextPC sim:/cpu/NextPC 0 -cancel 10
	mem load -filltype value -fillradix hexadecimal -startaddress 0 -endaddress 0 -filldata {00000000} /cpu/Register1/regFile
	mem load -filltype value -fillradix hexadecimal -startaddress 8 -endaddress 10 -filldata {00000000 00000004 00000004} /cpu/Register1/regFile
	mem load -filltype value -fillradix hexadecimal -startaddress 20 -endaddress 23 -filldata {0000000C 00000005 00000008 00000003} /cpu/Register1/regFile
	mem load -filltype value -fillradix hexadecimal -startaddress 0 -endaddress 7 -filldata {00 00 00 04 00 00 00 08} /cpu/DMemory/memFile
	mem load -filltype value -fillradix hexadecimal -filldata {00} /cpu/InstMem/memFile
}

proc sim_run {} {
	run 1000ns
}

proc sim_load_example_1 {} {
	sim_reset
	mem load -filltype value -fillradix hexadecimal -startaddress 0 -endaddress 31 -filldata {8D 15 00 00 8D 16 00 04 02 B6 78 2A 11 E0 00 02 02 43 88 22 08 00 00 07 02 53 88 20 AD 11 00 0C} /cpu/InstMem/memFile
}

proc sim_load_example_2 {} {
	sim_reset
	mem load -filltype value -fillradix hexadecimal -startaddress 0 -endaddress 7 -filldata {EB A0 00 04 EF B0 00 00} /cpu/InstMem/memFile
}
