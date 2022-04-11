def replaceMacros(line, macros):
    for micro in macros:
        # re.sub(micro, macros[micro], line)
        line = line.replace(micro, macros[micro])
    return line

# filename = input("Filepath: ")
filename = "./Examples/example_preprocessor.hallo"

input_file = open(filename, 'r')
output_file = open("processed_file.hallo", 'w')

macros = {}
skip = False
for line in input_file:
    words = line.replace("\n","").split(" ");
    words.append("\n")
    if words[0] == "let":
        micro = ""
        macro = ""
        for i in range(1, len(words)):
            if words[i] == "\n":
                break
            elif words[i] == "be":
                macros[words[i+1]] = macro[1:]
                micro = words[i+1]
            else:
                macro += " " + words[i]
        if micro == "":
            print("\nError in Macros\n")
        output_file.write("\n")
    elif "skip" in words:
        output_file.write("\n")
        skip = not skip
    elif skip:
        output_file.write("\n")
    else:
        output_file.write(replaceMacros(line, macros))

# print(macros)
output_file.close()
input_file.close()


# ./Examples/example_preprocessor.hallo