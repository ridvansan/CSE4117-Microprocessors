import re
import sys


#An assembler for the Reptile-8 and Bird CPU with the 12 bit and 16 bit address sizes.


opcodes={
    "ldi":0x1,
    "ld":0x2,
    "st":0x3,
    "jz":0x4,
    "jmp":0x5,
    "alu":0x7,
    "push":0x8,
    "pop":0x9,
    "call":0xa,
    "ret":0xb
}
alucodes={
    "add":0x0,
    "sub":0x1,
    "and":0x2,
    "or":0x3,
    "xor":0x4,
    "not":0x5,
    "mov":0x6,
    "inc":0x7,
    "dec":0x8
}
reptile_8_alucodes={
    "not":0x0,
    "mov":0x1,
    "inc":0x2,
    "dec":0x3
}

#A dictionary for jump labels.
#Key is a string of the name of the label. And value is an array with the size of 2
#First element contains the address of the label
#Second element contains an array with the line numbers where labels called from. 
jumptable={
}

datatable={
}

machine_code = []

register_bit_size = 3
address_bit_size = 12


def get_parameters(line):
    #Split the line by tabs and spaces
    parameters = re.split("\s+|\t",line)
    if parameters[len(parameters)-1] == "":
        parameters.pop()
    label = parameters[0]
    instruction = 0
    dest = 0
    src1 = 0
    src2 = 0
    #Fill the variables due to length of the parameter in order to avoid array border infringement
    if len(parameters) > 1:
        instruction = parameters[1]
        if len(parameters) > 2:
            dest = parameters[2]
            if len(parameters) > 3:
                src1 = parameters[3]
                if len(parameters) > 4:
                    src2 = parameters[4]
    return label,instruction,dest,src1,src2

#Adding the label to the table if not added
#If it is added check it is created by the add_jump_request function else throw an error.
def add_to_jumptable(name,current_line):
    if name not in jumptable.keys():
        jumptable[name] = [current_line,[]]
    else:
        if jumptable[name][0] == -1:
            jumptable[name][0] = current_line
        else:
            print(f"Error: 2 jumppoints is declared with the same name '{name}'")

#Adding the line to the tables request array.
#If the label is not created, creates one with the address of -1 and adds the address of the request
def add_jump_request(name,assembly_line):
    if name not in jumptable.keys():
        jumptable[name] = [-1,[]]
    jumptable[name][1].append(assembly_line)

def get_offset(name,current_line):
    if name in jumptable.keys():
        result =  jumptable[name][0] - current_line - 1
        if result < 0:
            result += (pow(2,address_bit_size))
        return result & (pow(2,address_bit_size)-1)
    else:
        print(f"in line {current_line}: Address {name} is not found on declared addresses.")

#implementation of .space is ignored in this phase of development
def add_to_datatable(name,value):
    if name not in datatable.keys():
        datatable[name] = [[value,-1],[]]
    else:
        if datatable[name][0][0] == -1:
            datatable[name][0][0] = value
        else:
            raise Exception(f"Error: to variables created with the same name '{name}'")

def add_data_request(name,assembly_line):
    if name not in datatable.keys():
        datatable[name] = [[-1,-1],[]]
    datatable[name][1].append(assembly_line)

def get_data_offset(name):
    if name in datatable.keys():
        print(name)
        result =  datatable[name][0][1]
        if result < 0:
            result += (pow(2,address_bit_size)-1)
        return result & (pow(2,address_bit_size)-1)
    return 0
        

def get_data(line):
    #Split the line by tabs and spaces
    parameters = re.split("\s+|\t",line)
    if parameters[len(parameters)-1] == "":
        parameters.pop()
    name = parameters[1][:-1]
    value = parameters[2]
    return name,value



#Argument Handling (only reads the first argument if there is no argument than use "example_program.txt")
if len(sys.argv) == 1:
    lines = open("example_program.txt","r").readlines()
if len(sys.argv) == 2:
    lines = open(sys.argv[1],"r").readlines()

#in order to check the which section of the code is processing (0 for .data, 1 for .code)
status = 0

#First Iteration
assembly_idx = 0
for line in lines:
    
    parameters = re.split("\s+|\t",line)
    #Check the line is a comment or not
    if line[:2] == "//":
        continue

    if parameters[0] == ".data":
        status = 1
        continue

    if parameters[0] == ".code":
        status = 2
        continue

    if status == 1:
        a,b = get_data(line)
        add_to_datatable(a,b)

    if status == 2:
        label,instruction,dest,src1,src2 = get_parameters(line)
        if label != "":
            add_to_jumptable(label,assembly_idx)
        if instruction in alucodes.keys():
            if (instruction == "add") or (instruction == "sub") or (instruction == "or") or (instruction == "and")  or (instruction == "xor"):
                binary = (opcodes["alu"] << 12) + (alucodes[instruction] << 9) + (int(src1) << 6) + (int(src2) << 3) + (int(dest))
            elif instruction == "mov" or instruction == "not":
                binary = (opcodes["alu"] << 12) + (0x7<<9) + (reptile_8_alucodes[instruction] << 6) + (int(src1) << 3) + (int(dest))
            elif instruction == "inc" or instruction == "dec":
                binary = (opcodes["alu"] << 12) + (0x7<<9) + (reptile_8_alucodes[instruction] << 6) + (int(dest) << 3) + (int(dest))
        if instruction == "ldi":
            binary = (opcodes[instruction]<< 12) + (int(dest) & 0x7)
            machine_code.append(binary)
            assembly_idx += 1
            if src1.isnumeric():
                binary = (int(src1) & 0xffff)
            else:
                binary = 0x0000
                add_data_request(src1,assembly_idx)
        elif instruction == "ld":
            binary = (opcodes[instruction]<< 12) + ((int(dest) << 3)) + (int(src1))
        elif instruction == "st":
            binary = (opcodes[instruction]<< 12) + ((int(dest) << 6)) + (int(src1) << 3)
        elif (instruction == "jmp") or (instruction == "jz") or (instruction == "call"):
            if address_bit_size == 12:
                binary = opcodes[instruction]<< 12
                if dest.isnumeric():
                    binary += (int(dest) & 0xfff)
                else:
                    add_jump_request(dest,assembly_idx) 
            elif address_bit_size == 16:
                binary = opcodes[instruction]<< 12
                machine_code.append(binary)
                assembly_idx += 1
                if src1.isnumeric():
                    binary = (int(src1) & 0xffff)
                else:
                    binary = 0x0000
                    add_jump_request(dest,assembly_idx)
        elif instruction == "push":
            binary = (opcodes[instruction]<< 12) + (int(dest) << 6)
        elif instruction == "pop":
            binary = (opcodes[instruction]<< 12) + (int(dest))
        elif instruction == "ret":
            binary = (opcodes[instruction]<< 12)
        else:
            print(f"Error: Instruction '{instruction}' does not exist or not supportted with this assembler")
        machine_code.append(binary)
        assembly_idx += 1


#Filling the jump addresses via getting offset from request to labels and adding into the code
for label in jumptable.keys():
    for i in jumptable[label][1]:
        machine_code[i] += get_offset(label,i)

for data in datatable.keys():
    machine_code.append(int(datatable[data][0][0]))
    assembly_idx+= 1
    datatable[data][0][1] += assembly_idx

for data in datatable.keys():
    for i in datatable[data][1]:
        machine_code[i] += get_data_offset(data)



ram = open("RAM","w")
ram.write("v2.0 raw\n")
for i in machine_code:
    ram.write(f"{format(i,'04x')}\n")