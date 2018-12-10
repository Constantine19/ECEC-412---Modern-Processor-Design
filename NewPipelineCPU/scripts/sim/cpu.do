# Start simulation
vsim cpu

# Windows
noview sim
noview objects
view transcript
view memory
view wave

# Add Waves
add wave -group "CPU Clock" -color "Grey60" -label "Clock" "sim:/cpu/clk"
# PC STAGE
add wave -group "PC Stage" -color "Red" -label "PC" "sim:/cpu/PC_pc"
add wave -group "PC Stage" -color "Red" -label "Predicted Address" "sim:/cpu/PC_predicted_address"
add wave -group "PC Stage" -color "Red" -label "Fallback Address" "sim:/cpu/PC_fallback_address"
# IF STAGE
add wave -group "IF Stage" -color "Orange" -label "PC" "sim:/cpu/IF_pc"
add wave -group "IF Stage" -color "Orange" -label "Instruction" "sim:/cpu/IF_instruction"
add wave -group "IF Stage" -color "Orange" -label "Predicted Address" "sim:/cpu/IF_predicted_address"
add wave -group "IF Stage" -color "Orange" -label "Fallback Address" "sim:/cpu/IF_fallback_address"
# ID STAGE
add wave -group "ID Stage" -color "Yellow" -label "PC" "sim:/cpu/ID_pc"
add wave -group "ID Stage" -color "Yellow" -label "Jump Address" "sim:/cpu/ID_jump_address"
add wave -group "ID Stage" -color "Yellow" -label "Jump Execute" "sim:/cpu/ID_jump_execute"
add wave -group "ID Stage" -color "Yellow" -label "Predicted Address" "sim:/cpu/ID_predicted_address"
add wave -group "ID Stage" -color "Yellow" -label "Fallback Address" "sim:/cpu/ID_fallback_address"
add wave -group "ID Stage" -color "Yellow" -label "ALUOp" "sim:/cpu/ID_aluop"
add wave -group "ID Stage" -color "Yellow" -label "ALUSrc" "sim:/cpu/ID_alusrc"
add wave -group "ID Stage" -color "Yellow" -label "Branch" "sim:/cpu/ID_branch"
add wave -group "ID Stage" -color "Yellow" -label "Memwrite" "sim:/cpu/ID_memwrite"
add wave -group "ID Stage" -color "Yellow" -label "Mem2reg" "sim:/cpu/ID_mem2reg"
add wave -group "ID Stage" -color "Yellow" -label "Regwrite" "sim:/cpu/ID_regwrite"
add wave -group "ID Stage" -color "Yellow" -label "StackOp" "sim:/cpu/ID_stackop"
add wave -group "ID Stage" -color "Yellow" -label "StackPushPop" "sim:/cpu/ID_stackpushpop"
add wave -group "ID Stage" -color "Yellow" -label "Read Data 1" "sim:/cpu/ID_read_data_1"
add wave -group "ID Stage" -color "Yellow" -label "Read Data 2" "sim:/cpu/ID_read_data_2"
add wave -group "ID Stage" -color "Yellow" -label "SE Immediate" "sim:/cpu/ID_se_immediate"
add wave -group "ID Stage" -color "Yellow" -label "Funct" "sim:/cpu/ID_funct"
add wave -group "ID Stage" -color "Yellow" -label "Read Address 1" "sim:/cpu/ID_read_address_1"
add wave -group "ID Stage" -color "Yellow" -label "Read Address 2" "sim:/cpu/ID_read_address_2"
add wave -group "ID Stage" -color "Yellow" -label "Write Address" "sim:/cpu/ID_write_address"

# Clear instruction memory
mem load -filltype value -filldata {0} "sim:/cpu/if_stage_i/instruction_memory/memory"
# Set instruction memory
    # lw $t0 $zero 8
    # lw $t1 $zero 12
    # addi $s0 $zero 298
    # add $t2 $t0 $t1
    # addi $t3 $t0 13
    # slt $t4 $t3 $s0
    # beq $t4 $zero 8
    # j 4
    # sw $t4 $zero 16
mem load -filltype value -fillradix hexadecimal -filldata {
    8C 08 00 08
    8C 09 00 0C
    20 10 01 2A
    01 09 50 20
    21 0B 00 0D
    01 70 60 0A
    10 0C 00 08
    08 00 00 04
    AC 0C 00 10
} -startaddress 0 -endaddress 35 "sim:/cpu/if_stage_i/instruction_memory/memory"

# Initialize registers
mem load -filltype value -fillradix hexadecimal -filldata {0} \
-startaddress 0 -endaddress 0 "sim:/cpu/id_stage_i/register_table_i/table"
mem load -filltype value -fillradix hexadecimal -filldata {
    8C080008
    8C09000C
    2010012A
    01095020
    210B000D
    0170600A
    100C0020
    08000010
    100C0020
    08000010
    AC0C0010
    0170600A
    100C0020
    08000010
    AC0C0010
    AC0C0010
} -startaddress 4 -endaddress 20 "sim:/cpu/id_stage_i/register_table_i/table"

# Start clock
force -freeze -repeat 100ns "sim:/cpu/clk" 0 0ns, 1 50ns

# Run
run 1500ns
