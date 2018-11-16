"""
Support script functions
"""
# --------------------------------- FUNCTIONS ---------------------------------

def flat(lst):
    """
    Flattens the given list. Concatenates all sublists into one

    :param lst: list of lists/values

    :return: flattened list
    """
    nlst = []
    for value in lst:
        if type(value) is list:
            nlst.extend(value)
        else:
            nlst.append(value)
    return nlst

def procedure(name, lines):
    """
    Tcl Procedure

    :param name: name of procedure
    :param lines: lines of procedure

    :return: tcl procedure string
    """
    return 'proc '+name+' {} {\n'+'\n'.join('\t'+line for line in lines)+'\n}'

def wave_group(name, color, signals):
    """
    An array of wave declarations all in the same group

    :param name: the name of the wave group
    :param color: the color of the wave group
    :param signals: signals (name, identifier pairs) in the group

    :return: array of wave declarations for the group
    """
    return [f'add wave -group "{name}" -color "{color}" -label "{sig[0]}" "{sig[1]}"' for sig in signals]

def mem_load(dest, start, fmt, data):
    """
    Tcl command to load memory data into memory location (assuming all memory
    is to be written)

    :param dest: identifier for destination memory location
    :param start: start location for writing memory
    :param fmt: format of memory to write
    :param data: data to write into memory

    :return: mem load Tcl command
    """
    endd = start + len(data) - 1
    dstr = '{' + ' '.join(format(value, fmt) for value in data) + '}'
    return 'mem load -filltype value -fillradix hexadecimal ' \
        + f'-startaddress {start} -endaddress {endd} -filldata {dstr} {dest}'

def mem_load_all(dest, fmt, datas):
    """
    Load all chunks into same destination memory

    :param dest: destination memory location
    :param fmt: format of memory to write
    :param data: chunks of data to write (position, data pairs)

    :return: array of tcl commands
    """
    return [mem_load(dest, start, fmt, data) for start, data in datas]

def mem_clear(dest):
    """
    Tcl command to clear all set all data in a memory location

    :param dest: identifier for destination memory location

    :return: mem clear Tcl command
    """
    return 'mem load -filltype value -fillradix hexadecimal -filldata {00} ' + dest

def clock(signal):
    """
    Declare clock signal

    :param signal: identifer for signal to force clock

    :return: declaration tcl command
    """
    return 'force -freeze '+signal+' 1 0, 0 {50 ns} -r 100ns'

def signal_for(time, signal, value):
    """
    Force a signal value for a given time

    :param time: the time to set for
    :param signal: identifer for signal to force
    :param value: value of signal to force

    :return: declaration tcl command
    """
    return f'force -freeze {signal} {value} 0 -cancel {time}'

def compile(component):
    """
    Compile component in work library

    :param component: vhdl file of the component

    :return: compile tcl command
    """
    return f'vcom -work work {component}'
