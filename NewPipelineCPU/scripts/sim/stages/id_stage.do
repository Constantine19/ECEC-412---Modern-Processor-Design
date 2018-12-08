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
add wave -group "IF Inputs" -color "Red" -label "Predicted Address" "sim:/id_stage/predicted_address_in"
add wave -group "IF Inputs" -color "Red" -label "Fallback Address" "sim:/id_stage/fallback_address_in"
add wave -group "IF Inputs" -color "Red" -label "Instruction" "sim:/id_stage/instruction"
add wave -group "WB Inputs" -color "Magenta" -label "WB Result" "sim:/id_stage/WB_result"
add wave -group "WB Inputs" -color "Magenta" -label "WB Write address" "sim:/id_stage/WB_write_address"
add wave -group "WB Inputs" -color "Magenta" -label "WB Regwrite" "sim:/id_stage/WB_regwrite"
add wave -group "Outputs" -color "Cyan" -label "Predicted Address" "sim:/id_stage/predicted_address_out"
add wave -group "Outputs" -color "Cyan" -label "Fallback Address" "sim:/id_stage/fallback_address_out"
