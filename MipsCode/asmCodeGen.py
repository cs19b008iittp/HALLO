filename = "./tac.txt"

input_file = open(filename, 'r')
output_file = open("asm.hallo", 'w')

mips_table = {}

fp = -8

for line in input_file:
    flag = ""
    command = line.replace("\n","").split(" ")
    if (len(command) == 5 and command[1] == "="):
        if not command[2].isdigit():
            output_file.write("lw $t1 " + str(fp) + "(fp)")
            flag = "F"
            fp -= 4
            output_file.write("\n")
        else:
            flag = "T"

        if not command[4].isdigit():
            output_file.write("lw $t2 " + str(fp) + "(fp)")
            flag += "F"
            fp -= 4
            output_file.write("\n")
        else:
            flag += "T"

        if command[3] == "+":
            output_file.write("add ")
        elif command[3] == "-":
            output_file.write("sub ")
        elif command[3] == "*":
            output_file.write("mult ")
        elif command[3] == "/":
            output_file.write("div ")
        
        if flag == "FF":
            output_file.write("$t3 $t1 $t2")
        elif flag == "TF":
            output_file.write("$t3 " + str(command[2]) + " $t2")
        elif flag == "FT":
            output_file.write("$t3 $t1 " + str(command[4]))
        else:
            output_file.write("$t3 " + str(command[2]) + " " + str(command[4]))

        output_file.write("\n")
        output_file.write("add $t0 $t3 $zero\n")
        output_file.write("sw $t0 " + str(fp) + "(fp)\n")
        fp -= 4

    elif (len(command) == 3 and command[1] == "="):
        output_file.write("li $t0 " + command[2] + "\n")
    else:
        output_file.write(str(command))
        output_file.write("\n")

output_file.close()
input_file.close()