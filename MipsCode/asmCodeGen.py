# $t0: store from memory
# $t1, $t2, $t3: arithmetic operation
# $t4: get input
# $t5: 
# $t6 return data

filename = "./tac.txt"

head_input_file = open("data.txt", 'r')
input_file = open(filename, 'r')
output_file = open("asm.hallo", 'w')

mem = {}

fp = -8
tab = 1

output_file.write(".data\n")
for line in head_input_file:
    output_file.write("\t" + line)

output_file.write("\n.text\n.globl main\n\n")

for line in input_file:
    flag = ""
    command = line.replace("\n","").split(" ")
    if (len(command) == 5 and command[1] == "="):
        output_file.write(tab*"\t" + "#=====Arithmetic Assignment=====\n")
        if not command[2].isdigit():
            output_file.write(tab*"\t" + "lw $t1, " + str(fp) + "(fp)\n")
            flag = "F"
            fp -= 4
        else:
            flag = "T"

        if not command[4].isdigit():
            output_file.write(tab*"\t" + "lw $t2, " + str(fp) + "(fp)\n")
            flag += "F"
            fp -= 4
        else:
            flag += "T"

        if command[3] == "+":
            output_file.write(tab*"\t" + "add ")
        elif command[3] == "-":
            output_file.write(tab*"\t" + "sub ")
        elif command[3] == "*":
            output_file.write(tab*"\t" + "mult ")
        elif command[3] == "/":
            output_file.write(tab*"\t" + "div ")
        
        if flag == "FF":
            output_file.write("$t3, $t1, $t2")
        elif flag == "TF":
            output_file.write("$t3, " + str(command[2]) + ", $t2")
        elif flag == "FT":
            output_file.write("$t3, $t1, " + str(command[4]))
        else:
            output_file.write("$t3, " + str(command[2]) + ", " + str(command[4]))

        output_file.write("\n")
        output_file.write(tab*"\t" + "add $t0, $t3, $zero\n")
        output_file.write(tab*"\t" + "sw $t0, " + str(fp) + "(fp)\n")
        mem[command[0]] = str(fp) + "(fp)"
        fp -= 4

    elif (len(command) == 3 and command[1] == "="):
        output_file.write(tab*"\t" + "#=====Assignment=====\n")
        output_file.write(tab*"\t" + "li $t0, " + command[2] + "\n")
        output_file.write(tab*"\t" + "sw $t0, " + str(fp) + "(fp)\n")
        mem[command[0]] = str(fp) + "(fp)"
        fp -= 4
    elif ":" in command[0]:
        output_file.write(tab*"\t" + "#=====Block Begin=====\n")
        tab -= 1
        output_file.write(tab*"\t" + command[0] + "\n")
        tab += 1
    elif command[0] == "goto":
        output_file.write(tab*"\t" + "#=====Jump=====\n")
        output_file.write(tab*"\t" + "j " + command[1] + "\n")
    elif command[0] == "disp":
        output_file.write(tab*"\t" + "#=====Display=====\n")
        if '"' in command[1]:
            txt = ""
            for i in range(1, len(command)):
                txt += command[i] + " "
            output_file.write(tab*"\t" + "li $v0, 4\n")
            output_file.write(tab*"\t" + "la $a0, " + txt + "\n")
            output_file.write(tab*"\t" + "syscall\n")
        else:
            for i in range(1, len(command)):
                output_file.write(tab*"\t" + "li $v0, 1\n")
                output_file.write(tab*"\t" + "la $a0, " + command[i].replace(",", "") + "\n")
                output_file.write(tab*"\t" + "syscall\n") 
    elif command[0] == "get":
        output_file.write(tab*"\t" + "#=====Input=====\n")
        output_file.write(tab*"\t" + "li $v0, 5\n")
        output_file.write(tab*"\t" + "syscall\n")
        output_file.write(tab*"\t" + "move $t4, $v0\n")
    elif command[0] == "if":
        output_file.write(tab*"\t" + "#=====If Condition=====\n")
        output_file.write(tab*"\t" + "lw $t1, "  + "\n")
        output_file.write(tab*"\t" + "lw $t2, "  + "\n")
        output_file.write(tab*"\t" + "sub $t3, $t1, $t2\n")

        if command[2] == "=":
            output_file.write(tab*"\t" + "beq $t3, $zero, LL\n")
        elif command[2] == "<":
            output_file.write(tab*"\t" + "bltz $t3, LL\n")
        elif command[2] == ">":
            output_file.write(tab*"\t" + "bgtz $t3, LL\n")
        elif command[2] == "<=":
            output_file.write(tab*"\t" + "blez $t3, LL\n")
        elif command[2] == ">=":
            output_file.write(tab*"\t" + "bgez $t3, LL\n")

    elif command[0] == "":
        continue
    else:
        output_file.write(tab*"\t" + str(command) + "\n")

output_file.close()
input_file.close()