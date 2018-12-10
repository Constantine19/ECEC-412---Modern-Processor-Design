# Start simulation
vsim id_stage

# Windows
noview sim
noview objects
view transcript
view memory
view wave

# Add Waves
add wave -group "CPU Clock" -color "Grey60" -label "Clock" "sim:/id_stage/clk"
add wave -group "Branch Inputs" -color "White" -label "Branch Execute" "sim:/id_stage/branch_execute"
add wave -group "Memory Data" -color "Magenta" -label "Register Table" "sim:/id_stage/register_table_i/table"
add wave -group "IF Inputs" -color "Red" -label "PC" "sim:/id_stage/pc_in"
add wave -group "IF Inputs" -color "Red" -label "Predicted Address" "sim:/id_stage/predicted_address_in"
add wave -group "IF Inputs" -color "Red" -label "Fallback Address" "sim:/id_stage/fallback_address_in"
add wave -group "IF Inputs" -color "Red" -label "Instruction" "sim:/id_stage/instruction"
add wave -group "WB Inputs" -color "Orange" -label "WB Result" "sim:/id_stage/WB_result"
add wave -group "WB Inputs" -color "Orange" -label "WB Write address" "sim:/id_stage/WB_write_address"
add wave -group "WB Inputs" -color "Orange" -label "WB Regwrite" "sim:/id_stage/WB_regwrite"
add wave -group "Branch Outputs" -color "Yellow" -label "PC" "sim:/id_stage/pc_out"
add wave -group "Branch Outputs" -color "Yellow" -label "Predicted Address" "sim:/id_stage/predicted_address_out"
add wave -group "Branch Outputs" -color "Yellow" -label "Fallback Address" "sim:/id_stage/fallback_address_out"
add wave -group "Branch Outputs" -color "Yellow" -label "Jump Address" "sim:/id_stage/jump_address"
add wave -group "Branch Outputs" -color "Yellow" -label "Jump Execute" "sim:/id_stage/jump_execute"
add wave -group "ID Signals" -color "Green" -radix binary -label "ID AluOp" "sim:/id_stage/ID_aluop"
add wave -group "ID Signals" -color "Green" -label "ID AluSrc" "sim:/id_stage/ID_alusrc"
add wave -group "ID Signals" -color "Green" -label "ID Branch" "sim:/id_stage/ID_branch"
add wave -group "ID Signals" -color "Green" -label "ID MemRead" "sim:/id_stage/ID_memread"
add wave -group "ID Signals" -color "Green" -label "ID Mem2Reg" "sim:/id_stage/ID_mem2reg"
add wave -group "ID Signals" -color "Green" -label "ID RegWrite" "sim:/id_stage/ID_regwrite"
add wave -group "ID Signals" -color "Green" -label "ID StackOp" "sim:/id_stage/ID_stackop"
add wave -group "ID Signals" -color "Green" -label "ID StackPushPop" "sim:/id_stage/ID_stackpushpop"
add wave -group "ID Data" -color "Cyan" -label "ID Read Data 1" "sim:/id_stage/ID_read_data_1"
add wave -group "ID Data" -color "Cyan" -label "ID Read Data 2" "sim:/id_stage/ID_read_data_2"
add wave -group "ID Data" -color "Cyan" -label "ID Read Address 1" "sim:/id_stage/ID_read_address_1"
add wave -group "ID Data" -color "Cyan" -label "ID Read Address 2" "sim:/id_stage/ID_read_address_2"
add wave -group "ID Data" -color "Cyan" -label "ID SE Immediate" "sim:/id_stage/ID_se_immediate"
add wave -group "ID Data" -color "Cyan" -label "ID Funct" "sim:/id_stage/ID_funct"
add wave -group "ID Data" -color "Cyan" -label "ID Write Address" "sim:/id_stage/ID_write_address"

# Set clock
force -freeze -repeat 100 "sim:/id_stage/clk" 0 0, 1 50

# Set register memory
mem load -filltype value -fillradix hexadecimal -filldata {
    00000000
} -startaddress 0 -endaddress 0 "sim:/id_stage/register_table_i/table"
mem load -filltype value -fillradix hexadecimal -filldata {
    00000000
} -startaddress 29 -endaddress 29 "sim:/id_stage/register_table_i/table"
mem load -filltype value -fillradix hexadecimal -filldata {
    01234567 00000000 89ABCDEF
} -startaddress 5 -endaddress 7 "sim:/id_stage/register_table_i/table"
mem load -filltype value -fillradix hexadecimal -filldata {
    09807212 5BE3A890
} -startaddress 10 -endaddress 11 "sim:/id_stage/register_table_i/table"

# PC Out Should Equal PC In
set time 0
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/branch_execute" 0 $time
force -freeze "sim:/id_stage/pc_in" 32'hA1B2C3D4 $time

# Predicted Address Out Should Equal Predicted Address In
set time [expr $time + 100]
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/predicted_address_in" 32'hA3484C84 $time

# Fallback Address Out Should Equal Fallback Address In
set time [expr $time + 100]
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/fallback_address_in" 32'hAEDCBA98 $time

# Jump Address Should Equal last 25 bits of instruction left shifted by 2 bits
# concatenated with first four bits of PC
set time [expr $time + 100]
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/instruction" 32'h08D21321 $time

# Jump Execute Should Be 1 if Jump Address does not equal Predicted Address
set time [expr $time + 100]
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/predicted_address_in" 32'hA234B567 $time

# When opcode is ALU
# ID ALUOp should be 100
# ID RegSrc should be 0
# ID AluSrc should be 0
# ID Branch should be X
# ID MemWrite should be 0
# ID Mem2Reg should be 0
# ID RegWrite should be 1
# ID StackOp should be 0
# ID StackPushPop should be 0
set time [expr $time + 100]
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/instruction" 32'h00000000 $time

# When opcode is ADDI
# ID ALUOp should be 110
# ID RegSrc should be 1
# ID AluSrc should be 1
# ID Branch should be X
# ID MemWrite should be 0
# ID Mem2Reg should be 0
# ID RegWrite should be 1
# ID StackOp should be 0
# ID StackPushPop should be 0
set time [expr $time + 100]
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/instruction" 32'h20000000 $time

# When opcode is LW
# ID ALUOp should be 110
# ID RegSrc should be 1
# ID AluSrc should be 1
# ID Branch should be X
# ID MemWrite should be 0
# ID Mem2Reg should be 1
# ID RegWrite should be 1
# ID StackOp should be 0
# ID StackPushPop should be 0
set time [expr $time + 100]
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/instruction" 32'h8C000000 $time

# When opcode is SW
# ID ALUOp should be 110
# ID RegSrc should be 1
# ID AluSrc should be 1
# ID Branch should be X
# ID MemWrite should be 1
# ID Mem2Reg should be 0
# ID RegWrite should be 0
# ID StackOp should be 0
# ID StackPushPop should be 0
set time [expr $time + 100]
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/instruction" 32'hAC000000 $time

# When opcode is BEQ
# ID ALUOp should be 101
# ID RegSrc should be 1
# ID AluSrc should be 1
# ID Branch should be 1
# ID MemWrite should be 0
# ID Mem2Reg should be 0
# ID RegWrite should be 0
# ID StackOp should be 0
# ID StackPushPop should be 0
set time [expr $time + 100]
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/instruction" 32'h10000000 $time

# When opcode is J
# ID ALUOp should be 000
# ID RegSrc should be 0
# ID AluSrc should be 0
# ID Branch should be X
# ID MemWrite should be 0
# ID Mem2Reg should be 0
# ID RegWrite should be 0
# ID StackOp should be 0
# ID StackPushPop should be 0
set time [expr $time + 100]
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/instruction" 32'h08000000 $time

# When branch_execute is 1, regardless of what opcode is
# ID ALUOp should be 000
# ID RegSrc should be 0
# ID AluSrc should be 0
# ID Branch should be X
# ID MemWrite should be 0
# ID Mem2Reg should be 0
# ID RegWrite should be 0
# ID StackOp should be 0
# ID StackPushPop should be 0
set time [expr $time + 100]
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/branch_execute" 1 $time
force -freeze "sim:/id_stage/instruction" 32'h20000000 $time

# Read Data 1 should be data in register at address equal to
# bits 25-21 of instruction
set time [expr $time + 100]
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/branch_execute" 0 $time
force -freeze "sim:/id_stage/instruction" 32'h00A00000 $time

# Read Data 2 should be data in register at address equal to
# bits 20-16 of instruction
set time [expr $time + 100]
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/instruction" 32'h00070000 $time

# Read Address 1 should be equal to
# bits 25-21 of instruction
set time [expr $time + 100]
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/instruction" 32'h00A00000 $time

# Read Address 2 should be equal to
# bits 20-16 of instruction
set time [expr $time + 100]
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/instruction" 32'h00070000 $time

# SE Immediate should equal positive value equal
# to bits 14-0 of instruction if bit 15 is 0
set time [expr $time + 100]
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/instruction" 32'h00005ABC $time

# SE Immediate should equal negative value equal
# to bits 14-0 of instruction if bit 15 is 1
set time [expr $time + 100]
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/instruction" 32'h0000DABC $time

# Funct should be equal to bits 5-0 of instruction
set time [expr $time + 100]
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/instruction" 32'h0000001

# Write Address should be equal to bits 15-11 when opcode is ALU
set time [expr $time + 100]
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/instruction" 32'h000A5800

# Write Address should be equal to bits 20-16 when opcode is
# ADDI, LW, SW, or BEQ
set time [expr $time + 100]
# -----------------------------------------------------------------------------
force -freeze "sim:/id_stage/instruction" 32'h200A5800

# Run
set time [expr $time + 100]
run $time
