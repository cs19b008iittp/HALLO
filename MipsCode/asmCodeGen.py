filename = "./tac.txt"

input_file = open(filename, 'r')
output_file = open("asm.hallo", 'w')

mips_table = {}

fp = -8
tab = 1

for line in input_file:
    flag = ""
    command = line.replace("\n","").split(" ")
    if (len(command) == 5 and command[1] == "="):
        if not command[2].isdigit():
            output_file.write(tab*"\t" + "lw $t1, " + str(fp) + "(fp)")
            flag = "F"
            fp -= 4
            output_file.write("\n")
        else:
            flag = "T"

        if not command[4].isdigit():
            output_file.write(tab*"\t" + "lw $t2, " + str(fp) + "(fp)")
            flag += "F"
            fp -= 4
            output_file.write("\n")
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
        fp -= 4

    elif (len(command) == 3 and command[1] == "="):
        output_file.write(tab*"\t" + "li $t0, " + command[2] + "\n")
    elif ":" in command[0]:
        tab -= 1
        output_file.write(tab*"\t" + command[0])
        output_file.write("\n")
        tab += 1
    elif command[0] == "goto":
        output_file.write(tab*"\t" + "j " + command[1])
        output_file.write("\n")
    elif command[0] == "disp":
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
    elif command[0] == "":
        continue
    else:
        output_file.write(tab*"\t" + str(command))
        output_file.write("\n")

output_file.close()
input_file.close()