import sys

def extract_bytecodes(input_text, base_filename="extracted_bytecode_"):
    lines = input_text.splitlines()  # Split the input text into individual lines
    bytecodes = []  # List to store extracted bytecodes

    # Flags to detect when we are in a section containing bytecode
    in_bytecode_section = False

    for line in lines:
        if line.startswith("Binary:"):
            in_bytecode_section = True  # Start of bytecode section
            continue  # Skip the "Binary:" line

        if in_bytecode_section:
            if line.strip() == "":  # An empty line indicates the end of the bytecode section
                in_bytecode_section = False
                continue
            bytecodes.append(line.strip())  # Add the stripped line (bytecode) to the list
            in_bytecode_section = False  # Reset for the next bytecode section, assuming one bytecode per section

    # Save each bytecode to a separate file
    for index, bytecode in enumerate(bytecodes, start=1):
        output_filename = f"{base_filename}{index}.bytecode"
        with open(output_filename, 'w') as output_file:
            output_file.write(bytecode)
        print(f"Bytecode {index} saved to {output_filename}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <input_file_path>")
        sys.exit(1)

    input_file_path = sys.argv[1]
    base_filename = input_file_path.rsplit('.', 1)[0] + "_"  # Use the input file's name as the base filename

    with open(input_file_path, 'r') as file:
        input_text = file.read()

    extract_bytecodes(input_text, base_filename)
