"""
usage: python assembler.py [assembly file] [machine code file]

requires python 3.x

This assembler is assuming the bit breakdown as follows:
R-Type: 3 bits opcode, 2 bits destination register, 2 bits operand 1 register, 2 bits operand 2 register
I-Type: 3 bits opcode, 2 bits destination register, 4 bits immediate
B-Type: 3 bits opcode, 2 bits address register, 2 bits operand 1 register, 2 bits operand 2 register

US:
H-Type 3 op | 2 bits reg | 2 bits reg | 2 bits func
C-Type 3 op | 3 bits dst | 3 bits src
M-Type 3 op | 3 bits reg | 1 bits imm | 2 bits func
"""


import sys

# map registers to binary
registers = {
    "$0": "000",
    "$1": "001",
    "$2": "010",
    "$3": "011",
	"$4": "100",
    "$5": "101",
    "$6": "110",
    "$7": "111",
}

c_immediate = {
	"#4":"011",
	"#3":"010",
	"#2":"001",
	"#1":"000",
	"#-1":"111",
	"#-2":"110",
	"#-3":"101",
	"#-4":"100"
}

h_immediate = {
	"#4":"11",
	"#3":"10",
	"#2":"01",
	"#1":"00",
}

m_immediate = {
	"#0":"0",
	"#1":"1"
}

funct = {
 	"BXOR": "11",
 	"ADD": "00",
 	"ADDI": "01",
 	"SUB": "10",
	"SUBI": "11",
	"LOAD": "00",
	"STORE": "01",
	"NOT": "10",
}

noop = "010000000" #ADD $0, $1

# map opcode to binary
# NOTE: THIS WILL BE DIFFERENT FOR YOU!
opcode = {
	"BXOR": "000",
	"ADD": "010",
	"ADDI": "010",
	"SUB": "010",
	"SUBI": "010",
	"EQ": "001",
	"JAL": "011",
	"MOV": "100",
    "AND": "101",
    "SH": "119",
    "RXOR": "111",
    "LOAD": "000",
    "STORE": "000",
    "NOT": "000",
}

# classify instructions into different types
# NOTE: THIS WILL BE DIFFERENT FOR YOU!
htype = ['ADD', 'ADDI', 'SUB', 'SUBI', 'BXOR']
ctype = ['EQ', 'JAL', 'MOV', 'AND', 'SH', 'RXOR']
mtype = ['LOAD', 'STORE', 'NOT']

# NOTE: THIS WILL BE DIFFERENT FOR YOU!
comment_char = '//'
immediate_char = '#'

with (
    open(sys.argv[1], "r") as read,
    open(sys.argv[2], "w") as write
):
# with automatically handles file (no need for open and close)
    line = read.readline() # read a line

    # for every line
    while(line):
        # strip takes away whitespace from left and right
        line = line.strip()

        # split your comments out
        line = line.split(comment_char, 1)

        # store instruction and comment
        inst = line[0].strip()
        comment = line[1].strip()

        # split instruction into arguments
        inst = inst.split()

        # initialize the string that contains the machine code binary
        writeline = ''

        #empty lines are no-ops
        if inst[0] == "":
            writeline += noop

        # write the opcode
        if inst[0] in opcode:
            writeline += opcode[inst[0]]
        else:
            # if it an instruction that doesn't exist, exit
            sys.exit()
        
        #break down instructions by bits
        if inst[0] in htype:
            #take first two bits 
            writeline += registers[inst[1]][:2]
            if (inst[2][0] == "$"):
               writeline += registers[inst[2]][:2]   
            else:
                writeline += h_immediate[inst[2]]
            writeline += funct[inst[0]]
        elif inst[0] in ctype:
            writeline += registers[inst[1]]
            if (inst[2][0] == "$"):
                writeline += registers[inst[2]]
            else:
                writeline += c_immediate[inst[2]]
        elif inst[0] in mtype: #M type instructions
            writeline += registers[inst[1]]
            writeline += m_immediate[inst[2]]
            writeline += funct[inst[0]]
            #append immediate 
            #append function bits for m type
			
        # SystemVerilog ignores comments prepended with // with readmemb or readmemh
        writeline += ' //' + comment
        writeline += '\n'

        # write the line into the desired file
        write.write(writeline)

        # read the next line
        line = read.readline()
