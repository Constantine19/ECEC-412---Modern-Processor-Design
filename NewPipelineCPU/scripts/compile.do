# Initialize work library
vlib work

# Compile libraries ahead of time
vcom -work work helper.vhd

# Compile all
vcom -work work *.vhd
