# Outline of Code

This processor is organized by components. Code components will be broken down recursively. Each stage in the pipeline will be a component. Within each stage, corresponding parts will be implemented as components. Sequential logic components are implemented using processes, while combinatorial code is implemented using dataflow language.

Each component of code has corresponding TCL scripts to compile code and generate a test waveform in ModelSim.

The final piece of code is a script which will compile the VHDL code, compile example MIPS assembly code into machine code, load the code into a created virtual CPU, and execute the code, generating the waveform.
